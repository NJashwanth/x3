import 'package:flutter/material.dart';
import 'package:x3/ConfigurationScreen/ui/ConfigurationSettingsScreen.dart';
import 'package:x3/HomeScreen/ui/homeScreen.dart';
import 'package:x3/Login/ui/loginScreen.dart';
import 'package:x3/Splash/Bloc/SplashBloc.dart';
import 'package:x3/utils/TextUtils.dart';
import 'package:x3/utils/utils.dart';

import 'model/EnumForStateManagement.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashBloc _bloc = SplashBloc.getInstance();
  Key textKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
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
              return getLoadingStateWidget();
              break;
          }
          return getLoadingStateWidget();
        });
  }

  Column getLoadingStateWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        getLogo(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            PText(
              textKey: "Checking Configurations",
              key: textKey,
            ),
            CircularProgressIndicator(),
          ],
        )
      ],
    );
  }
}
