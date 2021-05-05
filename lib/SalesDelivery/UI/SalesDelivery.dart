import 'package:flutter/material.dart';
import 'package:x3/HomeScreen/model/UserTaskModel.dart';

class SalesDeliveryScreen extends StatefulWidget {
  final UserTaskModel userTaskModel;

  SalesDeliveryScreen(
    this.userTaskModel,
  );

  @override
  _SalesDeliveryScreenState createState() => _SalesDeliveryScreenState();
}

class _SalesDeliveryScreenState extends State<SalesDeliveryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: Container(child: Text("SalesDeliveryScreen"))));
  }
}
