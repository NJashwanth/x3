import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  ConfigurationSettingsBloc _bloc = ConfigurationSettingsBloc.getInstance();

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
    return StreamBuilder<bool>(
        stream: _bloc.loadingStream,
        initialData: false,
        builder: (context, snapshot) {
          if (snapshot.data) return getDefaultLoading();
          return getLoadedBody();
        });
  }

  SingleChildScrollView getLoadedBody() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(tag: "logo", child: getLogo()),
            Divider(),
            getHeading("WEB SERVICES SETTINGS"),
            getFormFields(),
            getButtons(),
          ],
        ),
      ),
    );
  }

  Widget getFormFields() {
    return Column(
      children: [
        getServerAndPortFields(),
        getTextFormField(_userNameController, "Username", "Username"),
        getTextFormField(_passwordController, "Password", "Password"),
        getTextFormField(_folderController, "Folder", "Folder",
            capitalise: true),
        getTextFormField(_languageController, "Language", "Language",
            capitalise: true),
      ],
    );
  }

  Row getServerAndPortFields() {
    return Row(
      children: [
        Expanded(
          child: getTextFormField(
              _serverController, "Server : sagex3.yourcompany.com", "Server",
              capitalise: true),
        ),
        Expanded(
          child: getTextFormField(_portNumberController, "Port : 8124", "Port",
              textInputFormatter: FilteringTextInputFormatter.digitsOnly,
              textInputType: TextInputType.numberWithOptions(
                  decimal: true, signed: false)),
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
      _bloc.changeLoadingState(true);
      String responseFromServer =
          await _bloc.testConfigurations(configurationSettingsModel);
      _bloc.changeLoadingState(false);
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
      _bloc.changeLoadingState(true);

      String responseFromServer =
          await _bloc.saveConfigurations(configurationSettingsModel);
      _bloc.changeLoadingState(false);

      if (responseFromServer == "Success")
        navigateToSplashScreen(context);
      else
        showErrorMessageInSnackBar(context, "Error", _scaffoldKey);
    }
  }

  ConfigurationSettings getUserEnteredConfigurationsSettings() {
    return new ConfigurationSettings(
        server: _serverController.text,
        port: _portNumberController.text,
        userName: _userNameController.text,
        password: _passwordController.text,
        folder: _folderController.text,
        language: _languageController.text);
  }
}
