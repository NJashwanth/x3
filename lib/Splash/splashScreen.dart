import 'package:flutter/material.dart';
import 'package:x3/Splash/Bloc/SplashBloc.dart';
import 'package:x3/utils/utils.dart';

import 'model/EnumForStateManagement.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashBloc _bloc = SplashBloc.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  Widget getBody() {
    return FutureBuilder<LoginStates>(
        future: _bloc.,
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [getLogo(), Text("Checking Configurations ")],
          );
        });
  }
}
