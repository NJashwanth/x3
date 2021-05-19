import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:x3/HomeScreen/model/UserTaskModel.dart';
import 'package:x3/StockChangeScreen/bloc/StockChangeBloc.dart';
import 'package:x3/StockChangeScreen/model/StockExchangeGridModel.dart';
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
  List<FLD> completeGridList = [];
  List<DataRow> rowList;
  List<DataColumn> columnList;

  @override
  void initState() {
    super.initState();
    this.userTaskModel = widget.userTaskModel;
    _scanLocationController.text = userTaskModel.yXDESTLOC;
    this.sourceDocumentNumber = userTaskModel.yXSOURCEDOC;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: getAppBar(userTaskModel.yXTASKNAM.toString(), type: false),
      drawer: DrawerInAppBar(),
      body: getBody(),
    );
  }

  Widget getBody() {
    return Column(
      children: [getTopWidget(), getButtons()],
    );
  }

  Widget getTopWidget() {
    return StreamBuilder<StockExchangeGridModel>(
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
      StockExchangeGridModel stockExchangeGridModel = await _bloc
          .getGridDataForStockExchange(_documentNumberController.text);
      _bloc.updateStreamList(stockExchangeGridModel ?? []);
      await dialog.hide();
    }
  }

  void onScanItemPressed() {
    print("Scan Item Pressed");
  }

  void onAddLocationPressed() {
    print("Add Location Pressed");
  }

  void onClearButtonPressed() {
    print("Clear Button Pressed");
    clearTextFormFields();
  }

  void onSendButtonPressed() {
    print("Send Button Pressed");
  }

  void clearTextFormFields() {
    _documentNumberController.clear();
    _scanItemBarCodeController.clear();
    _scanLocationController.clear();
  }

  void addDataToRowList(AsyncSnapshot<StockExchangeGridModel> snapshot) {
    if (snapshot.hasData &&
        snapshot.data != null &&
        snapshot.data.gRP != null &&
        snapshot.data.tAB != null) {
      completeGridList = snapshot.data.tAB.lIN.fLD;
      print("Snapshot data is = ${snapshot.data}");
      columnList = getDataColumnList(snapshot.data.gRP.fLD);
      rowList = snapshot.data.tAB.lIN.fLD.map((element) {
        return DataRow(
          cells: <DataCell>[
            /* DataCell(Text(element.nAME ?? "", softWrap: false),
                placeholder: true, showEditIcon: true, onTap: () {
              print("onTap");
            }),*/
            DataCell(Text(element.nAME ?? "", softWrap: false)),
            DataCell(Text(element.t ?? "", softWrap: false)),
            DataCell(Text(element.tYPE ?? "", softWrap: false)),
            DataCell(Text(element.nAME ?? "", softWrap: false)),
            DataCell(Text(element.t ?? "", softWrap: false)),
            DataCell(Text(element.tYPE ?? "", softWrap: false))
          ],
          selected: element.isChecked ?? true,
          onSelectChanged: (value) {
            onTapOnCheckBox(element, snapshot.data);
          },
        );
      }).toList();
    }
  }

  List<DataCell> getDataCellList(List<String> dataCellValues) {
    List<DataCell> listToReturn = [];
    for (String value in dataCellValues) {
      DataCell dataCell = DataCell(Text(value));
      listToReturn.add(dataCell);
    }
    return listToReturn;
  }

  List<DataColumn> getDataColumnList(List<FLD> fldList) {
    List<DataColumn> listToReturn = [];
    print(fldList);
    // listToReturn.add(getDataColumn(Text("Move To")));
    for (FLD fld in fldList) {
      listToReturn.add(getDataColumn(Text(fld.nAME)));
    }

    print(listToReturn);
    return listToReturn;
  }

  void onTapOnCheckBox(FLD element, StockExchangeGridModel data) {
    element.isChecked = !element.isChecked;
    _bloc.updateStreamList(data ?? []);
  }
}
