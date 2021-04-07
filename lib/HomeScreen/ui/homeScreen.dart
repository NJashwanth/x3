import 'package:flutter/material.dart';
import 'package:x3/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  final List<String> loginResponse;

  HomeScreen({this.loginResponse});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: getDrawer(context),
      appBar: getAppBar('Home Screen'),
      body: getBody(),
    );
  }

  Widget getBody() {
    return ListView.builder(
      itemCount: widget.loginResponse.length,
      itemBuilder: (context, index) {
        String title = widget.loginResponse[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(title),
          ),
        );
      },
    );
  }
}
