import 'package:flutter/material.dart';
import 'package:x3/HomeScreen/model/UserTaskModel.dart';
import 'package:x3/utils/utils.dart';

class StockExchangeScreen extends StatefulWidget {
  final UserTaskModel userTaskModel;
  StockExchangeScreen(this.userTaskModel);

  @override
  _StockExchangeScreenState createState() => _StockExchangeScreenState();
}

class _StockExchangeScreenState extends State<StockExchangeScreen> {
  TextEditingController _documentNumberController = new TextEditingController();
  TextEditingController _scanItemBarCodeController =
      new TextEditingController();
  TextEditingController _scanLocationController = new TextEditingController();
  UserTaskModel userTaskModel;

  @override
  void initState() {
    super.initState();
    this.userTaskModel = widget.userTaskModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(userTaskModel.yXTASKNAM),
      body: getBody(),
    );
  }

  Widget getBody() {
    return Column(
      children: [
        getTextFormField(
            context, _documentNumberController, "Document number", null),
        getRow(_scanItemBarCodeController),
        getRow(_scanLocationController),
      ],
    );
  }

  Widget getRow(TextEditingController _controller) {
    return Row(
      children: [
        Expanded(
          flex: 9,
          child:
              getTextFormField(context, _controller, "Scan Item Barcode", null),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: () {},
          ),
        )
      ],
    );
  }
}
