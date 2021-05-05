import 'package:flutter/material.dart';
import 'package:x3/HomeScreen/model/UserTaskModel.dart';

class InquiryScreen extends StatefulWidget {
  final UserTaskModel userTaskModel;

  InquiryScreen(
    this.userTaskModel,
  );

  @override
  _InquiryScreenState createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: Container(child: Text("InquiryScreen"))));
  }
}
