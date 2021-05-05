import 'package:flutter/material.dart';
import 'package:x3/HomeScreen/model/UserTaskModel.dart';

class MiscellaneousReceiptScreen extends StatefulWidget {
  final UserTaskModel userTaskModel;

  MiscellaneousReceiptScreen(
    this.userTaskModel,
  );

  @override
  _MiscellaneousReceiptScreenState createState() =>
      _MiscellaneousReceiptScreenState();
}

class _MiscellaneousReceiptScreenState
    extends State<MiscellaneousReceiptScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(child: Text("MiscellaneousReceiptScreen"))));
  }
}
