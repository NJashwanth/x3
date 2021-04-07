import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:x3/ConfigurationScreen/ui/ConfigurationSettingsScreen.dart';
import 'package:x3/Login/bloc/LoginBloc.dart';
import 'package:x3/Login/model/LoginResponse.dart';
import 'package:x3/Login/model/userModel.dart';
import 'package:x3/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _userNameController =
      new TextEditingController(text: "USR01");
  TextEditingController _passwordController =
      new TextEditingController(text: "USR01");

  final _formKey = GlobalKey<FormState>();

  LoginBloc _bloc = LoginBloc.getInstance();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: getAppBar("Login"),
        body: getBody(),
      ),
    );
  }

  Widget getBody() {
    return StreamBuilder<bool>(
        stream: _bloc.loadingStream,
        builder: (context, snapshot) {
          if (snapshot.data) return getDefaultLoading();
          return getLoadedBody();
        });
  }

  Form getLoadedBody() {
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

  void onLoginButtonPressed() async {
    if (_formKey.currentState.validate()) {
      UserModel userModel =
          new UserModel(_userNameController.text, _passwordController.text);
      _bloc.changeLoadingState(true);
      LoginResponse responseFromServer = await _bloc.login(userModel);
      _bloc.changeLoadingState(false);
      if (responseFromServer.isSuccess)
        navigateToHomeScreen(context, responseFromServer.grp2);
      else
        showErrorMessageInSnackBar(context, "Error", _scaffoldKey);
    }
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
