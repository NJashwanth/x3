import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
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
  final FocusNode userNameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: getDrawer(context),
        appBar: getAppBar("Login"),
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
            Container(
                height: getScreenHeight(context) * 0.3,
                child: Hero(tag: "logo", child: getLogo())),
            Divider(),
            getHeading("LOGIN"),
            getTextFormField(
                context, _userNameController, "Username", "Username",
                currentFocusNode: userNameFocusNode,
                nextFocusNode: passwordFocusNode),
            getTextFormField(
                context, _passwordController, "Password", "Password",
                currentFocusNode: passwordFocusNode),
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
      ProgressDialog dialog = getProgressDialog(context);
      await dialog.show();
      LoginResponse responseFromServer = await _bloc.login(userModel);
      await dialog.hide();

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
