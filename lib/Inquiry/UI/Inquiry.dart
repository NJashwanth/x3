import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:x3/HomeScreen/model/UserTaskModel.dart';
import 'package:x3/utils/DrawerInAppBar.dart';
import 'package:x3/utils/textConstants.dart';
import 'package:x3/utils/utils.dart';

class InquiryScreen extends StatefulWidget {
  final UserTaskModel userTaskModel;

  InquiryScreen({
    this.userTaskModel,
  });

  @override
  _InquiryScreenState createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UserTaskModel userTaskModel;
  TextEditingController _documentNumberController = new TextEditingController();
  TextEditingController _scanItemBarCodeController =
      new TextEditingController();
  TextEditingController _scanLocationController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    // this.userTaskModel = widget.userTaskModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: getAppBar(/*userTaskModel.yXTASKNAM.toString()*/ "Inquiry",
            type: false),
        drawer: DrawerInAppBar(),
        body: getBody());
  }

  Widget getBody() {
    return Column(
      children: [getTopWidget(), getButtons()],
    );
  }

  Widget getTopWidget() {
    return buildFieldsAndGridWidget();
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

  getDocumentNumberWidget() {
    return getTextFormField(context, _documentNumberController,
        "Document number", "Document number",
        onEditingCompleted: onDocumentNumberEditingCompleted);
  }

  void onScanItemPressed() {}

  void onAddLocationPressed() {}

  Widget getGridWidget() {
    return Container();
  }

  void onDocumentNumberEditingCompleted() {}

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
  }

  void onSendButtonPressed() {}
}
