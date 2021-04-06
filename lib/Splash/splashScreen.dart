import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:x3/ConfigurationScreen/ui/ConfigurationSettingsScreen.dart';
import 'package:x3/HomeScreen/ui/homeScreen.dart';
import 'package:x3/Login/ui/loginScreen.dart';
import 'package:x3/Splash/Bloc/SplashBloc.dart';
import 'package:x3/utils/LoadingScreen.dart';
import 'package:x3/utils/utils.dart';

import 'model/EnumForStateManagement.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashBloc _bloc = SplashBloc.getInstance();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: getBody(),
      ),
    );
  }

  Widget getBody() {
    return StreamBuilder<LoginStates>(
        stream: _bloc.stateStream,
        builder: (context, snapshot) {
          switch (snapshot.data) {
            case LoginStates.login:
              return LoginScreen();
              break;
            case LoginStates.home:
              return HomeScreen();
              break;
            case LoginStates.configurationSettings:
              return ConfigurationSettingsScreen();
              break;
            case LoginStates.loading:
              return LoadingScreen();
              break;
            case LoginStates.errorInConfigure:
              return ConfigurationSettingsScreen();
              break;
            case LoginStates.splash:
              // TODO: Handle this case.
              break;
          }
          return getLoadingStateWidget();
        });
  }

  Column getLoadingStateWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Hero(tag: "logo", child: getLogo()),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Checking Configuration",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CircularProgressIndicator(),
            ),
          ],
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _bloc.state.stream.listen(onStateChange);
  }

  void onStateChange(LoginStates event) {
    if (event == LoginStates.errorInConfigure) {
      showErrorMessageInSnackBar(
          context, "Error Occurred! Please try again later", _scaffoldKey);
    }
  }
}
