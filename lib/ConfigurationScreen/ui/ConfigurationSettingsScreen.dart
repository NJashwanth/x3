import 'package:flutter/material.dart';
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
  TextEditingController _serverController = new TextEditingController();
  TextEditingController _portNumberController = new TextEditingController();
  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _folderController = new TextEditingController();
  TextEditingController _languageController = new TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  ConfigurationSettingsBloc _bloc = ConfigurationSettingsBloc.getInstance();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: getAppBar(),
        key: _scaffoldKey,
        body: getBody(),
      ),
    );
  }

  Widget getBody() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getLogo(),
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
        getTextFormField(_folderController, "Folder", "Folder"),
        getTextFormField(_languageController, "Language", "Language"),
      ],
    );
  }

  Row getServerAndPortFields() {
    return Row(
      children: [
        Expanded(
          child: getTextFormField(
            _serverController,
            "Server : sagex3.yourcompany.com",
            "Server",
          ),
        ),
        Expanded(
          child: getTextFormField(
            _portNumberController,
            "Port : 8124",
            "Port",
          ),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => onTestConfigurationsButtonPressed(),
        child: Container(
          alignment: Alignment.center,
          width: 150,
          height: 80,
          decoration: BoxDecoration(border: Border.all(color: Colors.red)),
          child: getButtonData(
              FontAwesomeIcons.database, "Test Connection", Colors.red),
        ),
      ),
    );
  }

  Widget getSaveButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => onSaveButtonPressed(),
        child: Container(
          alignment: Alignment.center,
          width: 150,
          height: 80,
          color: Colors.red,
          child: getButtonData(FontAwesomeIcons.save, "Save", Colors.white),
        ),
      ),
    );
  }

  void onTestConfigurationsButtonPressed() {
    if (_formKey.currentState.validate()) {
      ConfigurationSettingsModel configurationSettingsModel =
          new ConfigurationSettingsModel(
              server: _serverController.text,
              port: _portNumberController.text,
              userName: _userNameController.text,
              password: _passwordController.text,
              folder: _folderController.text,
              language: _languageController.text);
      _bloc.testConfigurations(configurationSettingsModel);
    }
  }

  onSaveButtonPressed() {
    if (_formKey.currentState.validate()) {
      ConfigurationSettingsModel configurationSettingsModel =
          new ConfigurationSettingsModel(
              server: _serverController.text,
              port: _portNumberController.text,
              userName: _userNameController.text,
              password: _passwordController.text,
              folder: _folderController.text,
              language: _languageController.text);
      _bloc.saveConfigurations(configurationSettingsModel);
    }
  }

  Widget getAppBar() {
    return AppBar(
      title: Text(
        "Configurations Settings",
      ),
    );
  }
}
