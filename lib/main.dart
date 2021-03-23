import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:x3/Splash/splashScreen.dart';
import 'package:x3/utils/utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDirectory =
      await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);

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
          inputDecorationTheme: buildInputDecorationTheme(),
          scaffoldBackgroundColor: Colors.red.shade50),
      home: SplashScreen(),
    );
  }
}
