import 'package:flutter/material.dart';
import 'package:x3/Login/ui/loginScreen.dart';
import 'package:x3/utils/utils.dart';

class SplashScreenUi extends StatefulWidget {
  @override
  _SplashScreenUiState createState() => _SplashScreenUiState();
}

class _SplashScreenUiState extends State<SplashScreenUi>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 7),
    );

    animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: animateLogo(),
    );
  }

  Widget animateLogo() {
    return Column(
      children: [
        new Container(
          alignment: Alignment.center,
          color: Colors.white,
          child: Hero(
            tag: "logo",
            child: new AnimatedBuilder(
              animation: animationController,
              child: new Container(
                height: 150.0,
                width: 150.0,
                child: new Image.asset('assets/Logo-CircleX_50px.png'),
              ),
              builder: (BuildContext context, Widget _widget) {
                return new Transform.rotate(
                  angle: animationController.value * 50,
                  child: _widget,
                );
              },
            ),
          ),
        ),
        RaisedButton(
          onPressed: () => navigate(),
        )
      ],
    );
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

  void navigate() {
    animationController.dispose();
    Navigator.pushAndRemoveUntil(
      context,
      _createRoute(),
      (route) => false,
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration: Duration(seconds: 5),
      pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.easeInCirc;
        var tween = Tween(begin: begin, end: end);
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
