import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:x3/HomeScreen/model/UserTaskModel.dart';
import 'package:x3/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  final List<UserTaskModel> loginResponse;

  HomeScreen({this.loginResponse});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey key = new GlobalKey();
  List<UserTaskModel> loginResponse;

  @override
  void initState() {
    super.initState();
    this.loginResponse = widget.loginResponse;
    loginResponse.sort((a, b) {
      return a.yXTASKORD.compareTo(b.yXTASKORD);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: getDrawer(context),
      appBar: AppBar(
        title: Text("Choose a Task"),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    return loginResponse.length == 0
        ? getNoDataWidget()
        : ListView.builder(
            itemCount: loginResponse.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: listTile(widget.loginResponse[index]),
              );
            },
          );
  }

  ListTile listTile(UserTaskModel loginResponse) {
    return ListTile(
      onTap: () => onListTileTapped(),
      leading: getLeading(loginResponse),
      title: Text(loginResponse.yXTASKNAM),
      subtitle: Text(loginResponse.yXTASKDESC),
    );
  }

  Widget getLeading(UserTaskModel loginResponse) {
    switch (loginResponse.yXGUITY) {
      case "Stock Change":
        return Icon(FontAwesomeIcons.warehouse);
        break;
      case 'Miscellaneous Receipt':
        return Icon(FontAwesomeIcons.pallet);
        break;
      case 'Sales Delivery':
        return Icon(FontAwesomeIcons.truckLoading, color: Colors.blueAccent);
        break;
      default:
        return Icon(FontAwesomeIcons.barcode);
        break;
    }
  }

  void onListTileTapped() {}
}
