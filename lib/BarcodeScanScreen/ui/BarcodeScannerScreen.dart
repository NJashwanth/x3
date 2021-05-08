import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:x3/BarcodeScanScreen/Bloc/BarcodeScannerBloc.dart';
import 'package:x3/BarcodeScanScreen/Model/BarcodeScannerGridModel.dart';
import 'package:x3/HomeScreen/model/UserTaskModel.dart';
import 'package:x3/utils/DrawerInAppBar.dart';
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
  List<BarCodeGridModel> barCodeModelList = [];

  bool disableKeyboard = true;
  BarCodeScannerBloc _bloc = BarCodeScannerBloc.getInstance();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    this.userTaskModel = widget.userTaskModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar(userTaskModel.yXTASKNAM.toString()),
        drawer: DrawerInAppBar(),
        body: getBody());
  }

  Widget getBody() {
    return Column(
      children: [getTopWidget(), getButtons()],
    );
  }

  Widget getTopWidget() {
    return Expanded(
        child: StreamBuilder<List<BarCodeGridModel>>(
            stream: _bloc.listOfGridStream,
            initialData: [],
            builder: (context, snapshot) {
              addDataToRowList(snapshot);
              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      getDocumentNumberField(context),
                      getRowTextFormFieldAndBarCode(
                          context,
                          _scanItemBarCodeController,
                          "Scan Item Barcode",
                          0,
                          onScanItemPressed),
                      getRowTextFormFieldAndBarCode(
                          context,
                          _scanLocationController,
                          "Scan Location",
                          3,
                          onScanLocationPressed),
                      getGridWidget(),
                    ],
                  ),
                ),
              );
            }));
  }

  void addDataToRowList(AsyncSnapshot<List<BarCodeGridModel>> snapshot) {
    if (snapshot.hasData && snapshot.data.isNotEmpty) {
      barCodeModelList = snapshot.data;
      rowList = snapshot.data.map(
        ((element) {
          return DataRow(
            cells: <DataCell>[
              DataCell(
                  Icon(element.isChecked
                      ? Icons.check_box
                      : Icons.check_box_outline_blank), onTap: () {
                onTapOnCheckBox(element, snapshot.data);
              }),
              DataCell(SelectableText(element.document)),
              DataCell(SelectableText(element.barcode)),
              DataCell(SelectableText(element.location)),
            ],
          );
        }),
      ).toList();
    } else {
      rowList = [];
      barCodeModelList = [];
    }
  }

  Widget getDocumentNumberField(BuildContext context) {
    return Row(children: [
      Expanded(
        child: getTextFormField(context, _documentNumberController,
            "Document number", "Document number"),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Bar Code Count : 0"),
      )
    ]);
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

  void onSendButtonPressed() {
    print("Send Button Pressed");
    if (barCodeModelList != [] && barCodeModelList.isNotEmpty) {
      List<BarCodeGridModel> listToSend = [];
      for (BarCodeGridModel barCodeGridModel in barCodeModelList) {
        if (barCodeGridModel.isChecked) listToSend.add(barCodeGridModel);
      }
      _bloc.addDataToServer(listToSend);
    }
  }

  void onScanItemPressed() {
    if (_formKey.currentState.validate()) {
      print("Validated");
      BarCodeGridModel barCodeGridModel = new BarCodeGridModel(
          _documentNumberController.text ?? "",
          _scanItemBarCodeController.text ?? "",
          _scanLocationController.text ?? "",
          true);
      _bloc.addItemToListStream(barCodeGridModel, barCodeModelList ?? []);
      clearTextFormFields();
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
      clearTextFormFields();
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
        columns: getDataRowForBarCodeScannerScreen(),
        rows: rowList ?? [],
      ),
    );
  }

  void onTapOnCheckBox(
      BarCodeGridModel element, List<BarCodeGridModel> completeList) {
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
}
