import 'package:flutter/material.dart';
import 'package:x3/Splash/splashScreen.dart';
import 'package:x3/utils/utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          appBarTheme: AppBarTheme(color: Colors.red),
          primarySwatch: Colors.blue,
          inputDecorationTheme: buildInputDecorationTheme(),
          scaffoldBackgroundColor: Colors.red.shade50),
      home: SplashScreen(),
    );
  }
}
