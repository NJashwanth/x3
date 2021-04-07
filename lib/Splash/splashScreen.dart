import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:x3/ConfigurationScreen/ui/ConfigurationSettingsScreen.dart';
import 'package:x3/HomeScreen/ui/homeScreen.dart';
import 'package:x3/Login/ui/loginScreen.dart';
import 'package:x3/Splash/Bloc/SplashBloc.dart';
import 'package:x3/utils/utils.dart';

import 'model/LoginState.dart';

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
    return StreamBuilder<LoginState>(
        stream: _bloc.loginStateStream,
        builder: (context, snapshot) {
          switch (snapshot.data.lState) {
            case LState.NEW:
              return ConfigurationSettingsScreen();
              break;
            case LState.SETTINGS_CONFIGURED:
              return LoginScreen();
              break;
            case LState.LOGGED_IN:
              return HomeScreen(
                loginResponse: snapshot.data.homeScreenData,
              );
              break;
            default:
              return getLoadingStateWidget();
              break;
          }
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
}
