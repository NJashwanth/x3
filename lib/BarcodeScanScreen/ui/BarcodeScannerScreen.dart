import 'package:flutter/material.dart';
import 'package:x3/HomeScreen/model/UserTaskModel.dart';

class BarCodeScannerScreen extends StatefulWidget {
  final UserTaskModel userTaskModel;

  BarCodeScannerScreen(
    this.userTaskModel,
  );

  @override
  _BarCodeScannerScreenState createState() => _BarCodeScannerScreenState();
}

class _BarCodeScannerScreenState extends State<BarCodeScannerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: Container(child: Text("BarCodeScannerScreen"))));
  }
}
