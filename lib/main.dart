import 'package:flutter/material.dart';
import 'package:x3/Splash/splashScreen.dart';
import 'package:x3/utils/utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'X3',
      theme: ThemeData(
          appBarTheme: AppBarTheme(color: Colors.red),
          primarySwatch: Colors.blue,
          primaryColor: Colors.red.shade600,
          buttonColor: Colors.red.shade400,
          dividerColor: Colors.red.shade100,
          accentColor: Colors.grey.shade400,
          inputDecorationTheme: buildInputDecorationTheme(context),
          scaffoldBackgroundColor: Colors.red.shade50),
      home: SplashScreen(),
    );
  }
}
