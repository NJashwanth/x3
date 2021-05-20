import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:x3/HomeScreen/model/UserTaskModel.dart';
import 'package:x3/StockChangeScreen/bloc/StockChangeBloc.dart';
import 'package:x3/StockChangeScreen/model/StockTransacionRequest.dart';
import 'package:x3/utils/DrawerInAppBar.dart';
import 'package:x3/utils/textConstants.dart';
import 'package:x3/utils/utils.dart';

class StockExchangeScreen extends StatefulWidget {
  final UserTaskModel userTaskModel;

  StockExchangeScreen(this.userTaskModel);

  @override
  _StockExchangeScreenState createState() => _StockExchangeScreenState();
}

class _StockExchangeScreenState extends State<StockExchangeScreen> {
  TextEditingController _documentNumberController = new TextEditingController();
  TextEditingController _scanItemBarCodeController =
      new TextEditingController();
  TextEditingController _scanLocationController = new TextEditingController();
  UserTaskModel userTaskModel;
  int sourceDocumentNumber;
  StockChangeBloc _bloc = StockChangeBloc.getInstance();
  final FocusNode scanItemFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Stock> completeGridList = [];
  List<DataRow> rowList;
  List<DataColumn> columnList;
  final FocusNode documentNumberFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    this.userTaskModel = widget.userTaskModel;
    _scanLocationController.text = userTaskModel.yXDESTLOC;
    this.sourceDocumentNumber = userTaskModel.yXSOURCEDOC;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onUserPressBackButton(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: getAppBar(userTaskModel.yXTASKNAM.toString(), type: false),
        drawer: DrawerInAppBar(),
        body: getBody(),
      ),
    );
  }

  onUserPressBackButton() {
    if (completeGridList.isNotEmpty) {
      showAlertDialog();
    } else
      Navigator.pop(context);
  }

  void showAlertDialog() {
    Widget okButton = TextButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget cancelButton = TextButton(
      child: Text("Discard changes and Go Back"),
      onPressed: () {
        Navigator.pop(context);
        onClearButtonPressed();
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
        title: Text("Warning"),
        content: Text("You didn't submitted your records."),
        actions: [cancelButton, okButton]);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget getBody() {
    return Column(
      children: [getTopWidget(), getButtons()],
    );
  }

  Widget getTopWidget() {
    return StreamBuilder<List<Stock>>(
        stream: _bloc.listOfGridStream,
        builder: (context, snapshot) {
          addDataToRowList(snapshot);
          return buildFieldsAndGridWidget();
        });
  }

  Expanded buildFieldsAndGridWidget() {
    return Expanded(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              getDocumentNumberWidget(),
              getRowTextFormFieldAndBarCode(context, _scanItemBarCodeController,
                  "Scan Item Barcode", 3, onScanItemPressed),
              getRowTextFormFieldAndBarCode(context, _scanLocationController,
                  "Scan Location", 3, onAddLocationPressed),
              getGridWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget getDocumentNumberWidget() {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: getTextFormField(context, _documentNumberController,
              "Document number", "Document number",
              enable: sourceDocumentNumber != 2 ? true : false,
              autoFocus: sourceDocumentNumber != 2 ? true : false,
              onEditingCompleted: onDocumentNumberEditingCompleted),
        ),
        Expanded(
          flex: 4,
          child: Container(
              alignment: Alignment.centerLeft,
              child: InkWell(
                  onTap: onAddButtonPressedForDocumentNumber,
                  child: Icon(Icons.add_circle))),
        )
      ],
    );
  }

  Widget getGridWidget() {
    return completeGridList.isNotEmpty
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            child: DataTable(
              showBottomBorder: true,
              headingRowColor: MaterialStateColor.resolveWith(
                  (states) => Colors.red.shade200),
              dataRowHeight: 50,
              dividerThickness: 2,
              sortColumnIndex: 2,
              showCheckboxColumn: true,
              columns: columnList,
              rows: rowList ?? [],
            ),
          )
        : Container();
  }

  Widget getButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        children: [
          getSendButton(),
          getClearButton(),
        ],
      ),
    );
  }

  Widget getClearButton() {
    return getOutLineButton(
        onClearButtonPressed,
        getButtonData(FontAwesomeIcons.trash, TextConstants.CLEAR_BUTTON_NAME,
            Colors.red));
  }

  Widget getSendButton() {
    return getFlatButton(
        onSendButtonPressed,
        getButtonData(FontAwesomeIcons.shareSquare,
            TextConstants.SEND_BUTTON_NAME, Colors.white));
  }

  Future<void> onDocumentNumberEditingCompleted() async {
    if (_documentNumberController.text.isNotEmpty) {
      await _bloc.getEntriesWithDocumentId();
    }
  }

  Future<void> onAddButtonPressedForDocumentNumber() async {
    if (_formKey.currentState.validate()) {
      ProgressDialog dialog = getProgressDialog(context);
      await dialog.show();
      /*StockExchangeGridModel stockExchangeGridModel = await _bloc
          .getGridDataForStockExchange(_documentNumberController.text);
      _bloc.updateStreamList(stockExchangeGridModel ?? []);*/
      List<Stock> stocksList = _bloc.getStocksList();
      _bloc.updateStreamList(stocksList ?? []);
      await dialog.hide();
    }
  }

  void onScanItemPressed() {
    print("Scan Item Pressed");
    if (_scanItemBarCodeController.text != null) {
      completeGridList.forEach((element) {
        if (element.yXITMREF == _scanItemBarCodeController.text) {
          element.isChecked = !element.isChecked;
        }
      });
      _bloc.updateStreamList(completeGridList);
    }
  }

  void onAddLocationPressed() {
    print("Add Location Pressed");
    if (_scanLocationController.text != null) {
      completeGridList.forEach((element) {
        if (element.isChecked) {
          element.yXDESTLOC = _scanLocationController.text;
        }
      });
    }
    _bloc.updateStreamList(completeGridList);
  }

  void onClearButtonPressed() {
    print("Clear Button Pressed");
    clearTextFormFields();
    _bloc.updateStreamList([]);
  }

  Future<void> onSendButtonPressed() async {
    print("Send Button Pressed");

    List<Stock> listToSend = [];
    List<Stock> listToLeft = [];
    for (Stock stock in completeGridList) {
      if (stock.isChecked)
        listToSend.add(stock);
      else
        listToLeft.add(stock);
    }
    print(listToSend.every((element) =>
        element.yXDESTLOC != null && element.yXDESTLOC.isNotEmpty));
    if (listToSend.isNotEmpty &&
        listToSend.every((element) =>
            element.yXDESTLOC != null && element.yXDESTLOC.isNotEmpty)) {
      ProgressDialog dialog = getProgressDialog(context);
      await dialog.show();
      print(userTaskModel.yXSOURCEPRG);
      GRP1 grp1 = new GRP1(
          yXDESC: userTaskModel.yXTASKNAM, yXSTOFCY: userTaskModel.yXSOUSTOFCY);
      StockTransacionRequest stockTransacionRequest =
          new StockTransacionRequest(
              gRP1: grp1,
              publicName: userTaskModel.yXSOURCEPRG,
              gRP2: listToSend,
              userTaskModel: userTaskModel);
      Map<String, dynamic> mapFromServer =
          await _bloc.createStockTransaction(stockTransacionRequest);
      print("mapFromServer for create Stock Transaction = $mapFromServer");
      await dialog.hide();

      if (mapFromServer != null) {
        clearTextFormFields();
        _bloc.updateStreamList(listToLeft);
        showErrorMessageInSnackBar(
            context, "Data Sent Successfully", _scaffoldKey);
        FocusScope.of(context).requestFocus(documentNumberFocusNode);
      } else
        showErrorMessageInSnackBar(
            context, "Error Occurred, Please Try Again Later", _scaffoldKey);
    } else
      showErrorMessageInSnackBar(
          context,
          "No Items Selected / Destination Location Cannot be empty",
          _scaffoldKey);
  }

  void clearTextFormFields() {
    _documentNumberController.clear();
    _scanItemBarCodeController.clear();
    _scanLocationController.clear();
  }

  void addDataToRowList(AsyncSnapshot<List<Stock>> snapshot) {
    if (snapshot.hasData && snapshot.data != null) {
      completeGridList = snapshot.data;
      completeGridList.sort((a, b) {
        if (b.isChecked ?? false) {
          return 1;
        }
        return -1;
      });
      columnList = getColumnList();
      rowList = completeGridList.map(((element) {
        element.isChecked = element.isChecked ?? false;
        return DataRow(
          cells: <DataCell>[
            DataCell(Text(element.yXITMREF, softWrap: false)),
            DataCell(Text(element.yXDESTLOC ?? "", softWrap: false)),
            DataCell(Text(element.yXPCU, softWrap: false)),
            DataCell(Text(element.yXQTY, softWrap: false)),
            DataCell(Text(element.yXSTA, softWrap: false)),
            DataCell(Text(element.yXLOCTYP, softWrap: false)),
            DataCell(Text(element.yXLOC, softWrap: false)),
            DataCell(Text(element.yXSTADEST, softWrap: false)),
            DataCell(Text(element.yXLOT, softWrap: false)),
            DataCell(Text(element.yXSUBLOT, softWrap: false))
          ],
          selected: element.isChecked,
          onSelectChanged: (value) {
            onTapOnCheckBox(element, snapshot.data);
          },
        );
      })).toList();
    }
  }

  List<DataColumn> getColumnList() {
    return [
      getDataColumn(Text("yXITMREF")),
      getDataColumn(Text("yXDESTLOC")),
      getDataColumn(Text("yXPCU")),
      getDataColumn(Text("yXQTY")),
      getDataColumn(Text("yXSTA")),
      getDataColumn(Text("yXLOCTYP")),
      getDataColumn(Text("yXLOC")),
      getDataColumn(Text("yXSTADEST")),
      getDataColumn(Text("yXLOT")),
      getDataColumn(Text("yXSUBLOT"))
    ];
  }

  void onTapOnCheckBox(Stock element, List<Stock> data) {
    element.isChecked = !element.isChecked;
    _bloc.updateStreamList(data ?? []);
  }
}
