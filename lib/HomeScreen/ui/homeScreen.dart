import 'package:flutter/material.dart';
import 'package:x3/HomeScreen/bloc/bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc _bloc = HomeBloc.getInstance();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  Widget getBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            onPressed: () => onConfigPressed(),
            child: Text("Config"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            onPressed: () => onLoginPressed(),
            child: Text("Login"),
          ),
        ),
      ],
    );
  }

  onConfigPressed() {
    _bloc.onConfigPressed();
  }

  onLoginPressed() {
    _bloc.onLoginPressed();
  }
}
