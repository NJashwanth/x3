import 'package:flutter/material.dart';
import 'package:x3/utils/utils.dart';

class SplashScreenUi extends StatefulWidget {
  @override
  _SplashScreenUiState createState() => _SplashScreenUiState();
}

class _SplashScreenUiState extends State<SplashScreenUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getLoadingStateWidget(),
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
}
