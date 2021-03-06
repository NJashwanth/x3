import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:x3/BarcodeScanScreen/Bloc/BarcodeScannerBloc.dart';
import 'package:x3/BarcodeScanScreen/Model/BarcodeScannerGridModel.dart';
import 'package:x3/HomeScreen/model/UserTaskModel.dart';
import 'package:x3/utils/DrawerInAppBar.dart';
import 'package:x3/utils/TextUtils.dart';
import 'package:x3/utils/textConstants.dart';
import 'package:x3/utils/utils.dart';

class BarCodeScannerScreen extends StatefulWidget {
  final UserTaskModel userTaskModel;

  BarCodeScannerScreen(
    this.userTaskModel,
  );

  @override
  _BarCodeScannerScreenState createState() => _BarCodeScannerScreenState();
}

class _BarCodeScannerScreenState extends State<BarCodeScannerScreen> {
  TextEditingController _documentNumberController = new TextEditingController();
  TextEditingController _scanItemBarCodeController =
      new TextEditingController();
  TextEditingController _scanLocationController = new TextEditingController();
  UserTaskModel userTaskModel;
  List<DataRow> rowList;
  List<UBEntriesGridModel> barCodeModelList = [];

  bool disableKeyboard = true;
  BarCodeScannerBloc _bloc = BarCodeScannerBloc.getInstance();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FocusNode documentNumberFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    this.userTaskModel = widget.userTaskModel;
    _scanLocationController.text = userTaskModel.yXDESTLOC;
    print("location is " + _scanLocationController.text);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onUserPressBackButton(),
      child: Scaffold(
          key: _scaffoldKey,
          appBar: getAppBar(userTaskModel.yXTASKNAM.toString(), type: false),
          drawer: DrawerInAppBar(),
          body: getBody()),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.clearDocumentsCount();
  }

  Widget getBody() {
    return Column(
      children: [getTopWidget(), getButtons()],
    );
  }

  Widget getTopWidget() {
    return Expanded(
        child: StreamBuilder<List<UBEntriesGridModel>>(
            stream: _bloc.listOfGridStream,
            initialData: [],
            builder: (context, snapshot) {
              addDataToRowList(snapshot);
              return buildFieldsAndGridWidgets(context);
            }));
  }

  SingleChildScrollView buildFieldsAndGridWidgets(BuildContext context) {
    return SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(children: [
              getDocumentNumberField(context),
              getRowTextFormFieldAndBarCode(context, _scanItemBarCodeController,
                  "Scan Item Barcode", 0, onScanItemPressed),
              getRowTextFormFieldAndBarCode(context, _scanLocationController,
                  "Scan Location", 3, onScanLocationPressed),
              getGridWidget()
            ])));
  }

  void addDataToRowList(AsyncSnapshot<List<UBEntriesGridModel>> snapshot) {
    if (snapshot.hasData && snapshot.data.isNotEmpty) {
      barCodeModelList = snapshot.data;
      rowList = snapshot.data.map(((element) {
        return DataRow(
          cells: <DataCell>[
            DataCell(Text(element.document, softWrap: false)),
            DataCell(Text(element.barcode, softWrap: false)),
            DataCell(Text(element.location, softWrap: false))
          ],
          selected: element.isChecked,
          onSelectChanged: (value) {
            onTapOnCheckBox(element, snapshot.data);
          },
        );
      })).toList();
    } else {
      rowList = [
        DataRow(
          cells: <DataCell>[
            DataCell(Container()),
            DataCell(Container()),
            DataCell(Container()),
          ],
          onSelectChanged: (value) {
            // onTapOnCheckBox(element, snapshot.data);
          },
        )
      ];
      barCodeModelList = [];
    }
  }

  Widget getDocumentNumberField(BuildContext context) {
    return StreamBuilder<int>(
        stream: _bloc.numberOfItemsStream,
        initialData: 0,
        builder: (context, snapshot) {
          return Row(children: [
            Expanded(
              flex: 6,
              child: getTextFormField(context, _documentNumberController,
                  "Document number", "Document number",
                  currentFocusNode: documentNumberFocusNode, validationType: 3),
            ),
            barcodeCountTextWidget(snapshot)
          ]);
        });
  }

  Expanded barcodeCountTextWidget(AsyncSnapshot<int> snapshot) {
    return Expanded(
      flex: 4,
      child: Visibility(
        visible: snapshot.data != null && snapshot.data != 0,
        child: Row(
          // mainAxisSize: MainAxisSize.min,

          children: [
            PText(
                textKey: TextConstants.BARCODE_COUNT_TEXT,
                textType: TextType.body2),
            PText(
                textKey: " : ${snapshot.data ?? 0}",
                textType: TextType.body2,
                type: false)
          ],
        ),
      ),
    );
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

  void onClearButtonPressed() {
    print("Clear Data");
    clearTextFormFields();
    _bloc.updateStreamList([]);
  }

  void onScanItemPressed() {
    if (_formKey.currentState.validate()) {
      print("Validated");
      UBEntriesGridModel barCodeGridModel = new UBEntriesGridModel(
          _documentNumberController.text,
          _scanItemBarCodeController.text,
          _scanLocationController.text ?? "",
          true);
      _bloc.addItemToListStream(barCodeGridModel, barCodeModelList ?? []);
      // clearTextFormFields();
    }
  }

  void clearTextFormFields() {
    _documentNumberController.clear();
    _scanItemBarCodeController.clear();
    _scanLocationController.clear();
  }

  void onScanLocationPressed() {
    if (_scanLocationController.text != null) {
      print("Validated");
      addLocationToTheItemsWithOutLocation();
      // clearTextFormFields();
    }
  }

  Widget getGridWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.zero,
      child: DataTable(
        showBottomBorder: true,
        headingRowColor:
            MaterialStateColor.resolveWith((states) => Colors.red.shade200),
        dataRowHeight: 50,
        dividerThickness: 2,
        sortColumnIndex: 2,
        showCheckboxColumn: true,
        columns: getDataRowForBarCodeScannerScreen(),
        rows: rowList ?? [],
      ),
    );
  }

  void onTapOnCheckBox(
      UBEntriesGridModel element, List<UBEntriesGridModel> completeList) {
    element.isChecked = !element.isChecked;
    _bloc.updateStreamList(completeList ?? []);
  }

  void addLocationToTheItemsWithOutLocation() {
    if (barCodeModelList != null && barCodeModelList.isNotEmpty) {
      barCodeModelList.forEach((element) {
        if (element.location.isEmpty)
          element.location = _scanLocationController.text;
      });
    }
    _bloc.updateStreamList(barCodeModelList ?? []);
  }

  Future<void> onSendButtonPressed() async {
    print("Send Button Pressed");
    if (barCodeModelList != [] && barCodeModelList.isNotEmpty) {
      List<UBEntriesGridModel> listToSend = [];
      List<UBEntriesGridModel> listToLeft = [];
      for (UBEntriesGridModel barCodeGridModel in barCodeModelList) {
        if (barCodeGridModel.isChecked)
          listToSend.add(barCodeGridModel);
        else
          listToLeft.add(barCodeGridModel);
      }
      if (listToSend.isNotEmpty) {
        ProgressDialog dialog = getProgressDialog(context);
        await dialog.show();

        int numberOfItems = await _bloc.addDataToServer(listToSend);
        print("No od Items Returned = $numberOfItems");
        await dialog.hide();
        if (numberOfItems != -1) {
          print("No of items = $numberOfItems");
          _bloc.addNoOfItemsToStream(numberOfItems);
          _bloc.updateStreamList([]);
          clearTextFormFields();
          showErrorMessageInSnackBar(
              context, "Data Sent Successfully", _scaffoldKey);
          FocusScope.of(context).requestFocus(documentNumberFocusNode);
        } else {
          _bloc.addNoOfItemsToStream(0);
          showErrorMessageInSnackBar(
              context, "Error Occurred, Please Try Again Later", _scaffoldKey);
        }
      } else
        showErrorMessageInSnackBar(context, "No Items Selected", _scaffoldKey);
    } else
      showErrorMessageInSnackBar(context, "No Items Selected", _scaffoldKey);
  }

  onUserPressBackButton() {
    if (barCodeModelList.isNotEmpty) {
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
}
