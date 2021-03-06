import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:x3/HomeScreen/model/UserTaskModel.dart';
import 'package:x3/utils/DrawerInAppBar.dart';
import 'package:x3/utils/textConstants.dart';
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
      drawer: DrawerInAppBar(),
      appBar: getAppBar(
        TextConstants.HOMESCREEN_APPBAR_TITLE,
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
              return listTile(widget.loginResponse[index]);
            },
          );
  }

  Widget listTile(UserTaskModel loginResponse) {
    print("Login Response HEAD LINE" + loginResponse.yXTASKNAM.toString());
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        child: ListTile(
          onTap: () => onListTileTapped(loginResponse),
          leading: getLeading(loginResponse),
          title: Text(loginResponse.yXTASKNAM),
          subtitle: Text(loginResponse.yXTASKDESC),
        ),
      ),
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

  void onListTileTapped(UserTaskModel userTaskModel) {
    print(userTaskModel.yXGUITY);
    switch (userTaskModel.yXGUITY) {
      case "Stock Change":
        navigateToStockChangeScreen(context, userTaskModel);
        break;
      case 'Miscellaneous Receipt':
        return navigateToMiscellaneousScreen(context, userTaskModel);
        break;
      case 'Sales Delivery':
        return navigateToSalesDeliveryScreen(context, userTaskModel);
        break;
      case 'Purchase Order Receipt':
        return navigateToPurchaseOrderReceiptScreen(context, userTaskModel);
        break;
      case 'Inquiry':
        return navigateToInquiryScreen(context, userTaskModel: userTaskModel);
        break;
      case 'Unintelligent Barcode':
        return navigateToBarCodeScannerScreen(context, userTaskModel);
        break;
      default:
        print("Default");
        break;
    }
  }
}
