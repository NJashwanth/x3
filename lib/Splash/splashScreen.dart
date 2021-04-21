import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    return getLoadingStateWidget();
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
    _bloc.loginStateController.stream.listen(onStateChange);
  }

  @override
  void dispose() {
    _bloc.clear();
    super.dispose();
  }

  void onStateChange(LoginState event) {
    switch (event.lState) {
      case LState.NEW:
        navigateToConfigurationSettingsScreen(context);
        break;
      case LState.SETTINGS_CONFIGURED:
        navigateToLoginScreen(context);
        break;
      case LState.LOGGED_IN:
        navigateToHomeScreen(context, event.homeScreenData);
        break;
      case LState.SPLASH:
        // TODO: Handle this case.
        break;
    }
  }
}
