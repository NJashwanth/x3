import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:x3/ConfigurationScreen/bloc/ConfigurationSettingsBloc.dart';
import 'package:x3/ConfigurationScreen/model/configurationSettingsModel.dart';
import 'package:x3/utils/utils.dart';

class ConfigurationSettingsScreen extends StatefulWidget {
  @override
  _ConfigurationSettingsScreenState createState() =>
      _ConfigurationSettingsScreenState();
}

class _ConfigurationSettingsScreenState
    extends State<ConfigurationSettingsScreen> {
  TextEditingController _serverController =
      new TextEditingController(text: "http://sagex3v12.germinit.com");
  TextEditingController _portNumberController =
      new TextEditingController(text: "8124");
  TextEditingController _userNameController =
      new TextEditingController(text: "Admin");
  TextEditingController _passwordController =
      new TextEditingController(text: "admin");
  TextEditingController _folderController =
      new TextEditingController(text: "GITDEV");
  TextEditingController _languageController =
      new TextEditingController(text: "eng");
  TextEditingController _urlController = new TextEditingController(
      text: "soap-generic/syracuse/collaboration/syracuse/CAdxWebServiceXmlCC");

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  ConfigurationSettingsBloc _bloc = ConfigurationSettingsBloc.getInstance();

  final FocusNode serverFocusNode = FocusNode();
  final FocusNode portFocusNode = FocusNode();
  final FocusNode userNameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode adminFocusNode = FocusNode();
  final FocusNode folderFocusNode = FocusNode();
  final FocusNode uRLFocusNode = FocusNode();

  final FocusNode lanFocusNode = FocusNode();
  String type = 'http';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: getAppBar("Configurations Settings"),
        key: _scaffoldKey,
        body: getBody(),
      ),
    );
  }

  Widget getBody() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(tag: "logo", child: getLogo()),
                  Divider(),
                  getHeading("WEB SERVICES SETTINGS"),
                  getFormFields(),
                ],
              ),
            ),
          ),
        ),
        getButtons(),
      ],
    );
  }

  Widget getFormFields() {
    return Column(
      children: [
        getRadioButtons(),
        getServerAndPortFields(),
        getTextFormField(context, _urlController, "URL", "URL",
            currentFocusNode: uRLFocusNode, nextFocusNode: userNameFocusNode),
        getTextFormField(context, _userNameController, "Username", "Username",
            currentFocusNode: userNameFocusNode,
            nextFocusNode: passwordFocusNode),
        getTextFormField(context, _passwordController, "Password", "Password",
            currentFocusNode: passwordFocusNode,
            nextFocusNode: folderFocusNode),
        getTextFormField(context, _folderController, "Folder", "Folder",
            capitalise: true,
            currentFocusNode: folderFocusNode,
            nextFocusNode: lanFocusNode),
        getTextFormField(context, _languageController, "Language", "Language",
            capitalise: true, currentFocusNode: lanFocusNode),
      ],
    );
  }

  Row getServerAndPortFields() {
    return Row(
      children: [
        Expanded(
          child: getTextFormField(context, _serverController,
              "Server : sagex3.yourcompany.com", "Server",
              capitalise: true,
              currentFocusNode: serverFocusNode,
              nextFocusNode: portFocusNode),
        ),
        Expanded(
          child: getTextFormField(
              context, _portNumberController, "Port : 8124", "Port",
              textInputFormatter: FilteringTextInputFormatter.digitsOnly,
              textInputType:
                  TextInputType.numberWithOptions(decimal: true, signed: false),
              currentFocusNode: portFocusNode,
              nextFocusNode: uRLFocusNode),
        ),
      ],
    );
  }

  Widget getButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getTestConnectionButton(),
          getSaveButton(),
        ],
      ),
    );
  }

  Widget getTestConnectionButton() {
    return getOutLineButton(
        onTestConfigurationsButtonPressed,
        getButtonData(
            FontAwesomeIcons.database, "Test Connection", Colors.red));
  }

  Widget getSaveButton() {
    return getFlatButton(onSaveButtonPressed,
        getButtonData(FontAwesomeIcons.save, "Save", Colors.white));
  }

  Future<void> onTestConfigurationsButtonPressed() async {
    if (_formKey.currentState.validate()) {
      ConfigurationSettings configurationSettingsModel =
          getUserEnteredConfigurationsSettings();
      ProgressDialog dialog = getProgressDialog(context);
      await dialog.show();
      String responseFromServer =
          await _bloc.testConfigurations(configurationSettingsModel);
      await dialog.hide();

      if (responseFromServer == "Success")
        successDialog();
      else
        failureDialog();
    }
  }

  void failureDialog() {
    return showDialogForSuccessAndFailureResponse(
        context, "Error", getFailureText(), getCrossIcon());
  }

  void successDialog() {
    return showDialogForSuccessAndFailureResponse(
        context, "Success", getSuccessText(), getSuccessIcon());
  }

  Future<void> onSaveButtonPressed() async {
    if (_formKey.currentState.validate()) {
      ConfigurationSettings configurationSettingsModel =
          getUserEnteredConfigurationsSettings();
      ProgressDialog dialog = getProgressDialog(context);
      await dialog.show();

      String responseFromServer =
          await _bloc.saveConfigurations(configurationSettingsModel);
      await dialog.hide();
      if (responseFromServer == "Success")
        navigateToSplashScreen(context);
      else
        showErrorMessageInSnackBar(context, responseFromServer, _scaffoldKey);
    }
  }

  ConfigurationSettings getUserEnteredConfigurationsSettings() {
    return new ConfigurationSettings(
        server: _serverController.text,
        port: _portNumberController.text,
        userName: _userNameController.text,
        password: _passwordController.text,
        folder: _folderController.text,
        language: _languageController.text,
        url: _urlController.text,
        urlType: type);
  }

  Widget getRadioButtons() {
    return getActionTypeRadioButtons();
  }

  Widget getActionTypeRadioButtons() {
    return Row(
      children: [
        Radio<String>(
          onChanged: (value) {
            setState(() {
              type = value;
            });
          },
          groupValue: type,
          value: 'http',
        ),
        Text(
          'Http ',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        Radio<String>(
          onChanged: (value) {
            setState(() {
              type = value;
            });
          },
          groupValue: type,
          value: 'https',
        ),
        Text(
          'Https ',
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );
  }
}
