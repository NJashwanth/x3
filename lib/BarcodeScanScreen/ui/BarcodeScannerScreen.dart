import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      children: [
        Expanded(
          child: Column(
            children: [
              getTextFormField(context, _documentNumberController,
                  "Document number", "Document number"),
              getRowTextFormFieldAndBarCode(
                  context, _scanItemBarCodeController, "Scan Item Barcode"),
              getRowTextFormFieldAndBarCode(
                  context, _scanLocationController, "Scan Location"),
              getGridWidget(),
            ],
          ),
        ),
        getButtons()
      ],
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
    print("Clear Button Pressed");
  }

  void onSendButtonPressed() {
    print("Send Button Pressed");
  }

  Widget getGridWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.zero,
      child: DataTable(
        onSelectAll: (b) => null,
        showBottomBorder: true,
        headingRowColor:
            MaterialStateColor.resolveWith((states) => Colors.red.shade200),
        dataRowHeight: 50,
        dividerThickness: 2,
        columns: getDataRowForBarCodeScannerScreen(),
        rows: [],
      ),
    );
  }
}
