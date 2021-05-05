import 'package:flutter/material.dart';
import 'package:x3/HomeScreen/model/UserTaskModel.dart';

class PurchaseOrderReceipt extends StatefulWidget {
  final UserTaskModel userTaskModel;

  PurchaseOrderReceipt(
    this.userTaskModel,
  );

  @override
  _PurchaseOrderReceiptState createState() => _PurchaseOrderReceiptState();
}

class _PurchaseOrderReceiptState extends State<PurchaseOrderReceipt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: Container(child: Text("Purchase Order Receipt"))));
  }
}
