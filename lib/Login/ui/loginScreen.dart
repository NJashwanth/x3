import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:x3/ConfigurationScreen/ui/ConfigurationSettingsScreen.dart';
import 'package:x3/Login/bloc/LoginBloc.dart';
import 'package:x3/Login/model/userModel.dart';
import 'package:x3/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  LoginBloc _bloc = LoginBloc.getInstance();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: getAppBar(),
        body: getBody(),
      ),
    );
  }

  Widget getBody() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(tag: "logo", child: getLogo()),
            Divider(),
            getHeading("LOGIN"),
            getTextFormField(_userNameController, "Username", "Username"),
            getTextFormField(_passwordController, "Password", "Password"),
            getLoginButton(),
          ],
        ),
      ),
    );
  }

  Widget getLoginButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => onLoginButtonPressed(),
        child: Container(
          alignment: Alignment.center,
          width: 150,
          height: 80,
          color: Colors.red,
          child: getButtonData(FontAwesomeIcons.user, "Login", Colors.white),
        ),
      ),
    );
  }

  onLoginButtonPressed() {
    if (_formKey.currentState.validate()) {
      UserModel userModel =
          new UserModel(_userNameController.text, _passwordController.text);
      _bloc.login(userModel);
    }
  }

  Widget getAppBar() {
    return AppBar(
      backgroundColor: Colors.red,
      actions: [getActions()],
      title: Text("Login"),
    );
  }

  Widget getActions() {
    return TextButton(
      child: Text(
        "Configure Settings",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () => onPressed(),
    );
  }

  onPressed() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfigurationSettingsScreen(),
        ));
  }
}
