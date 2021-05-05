import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:x3/BarcodeScanScreen/ui/BarcodeScannerScreen.dart';
import 'package:x3/ConfigurationScreen/ui/ConfigurationSettingsScreen.dart';
import 'package:x3/HomeScreen/model/UserTaskModel.dart';
import 'package:x3/HomeScreen/ui/homeScreen.dart';
import 'package:x3/Inquiry/UI/Inquiry.dart';
import 'package:x3/Login/ui/loginScreen.dart';
import 'package:x3/Miscellaneous%20Receipt/UI/MiscellaneousReceipt.dart';
import 'package:x3/PurchaseOrderReceipt/UI/Purchase_Order_Receipt.dart';
import 'package:x3/SalesDelivery/UI/SalesDelivery.dart';
import 'package:x3/Splash/splashScreen.dart';
import 'package:x3/StockChangeScreen/ui/stockExchangeScreen.dart';
import 'package:x3/utils/TextUtils.dart';
import 'package:x3/utils/textConstants.dart';

Widget getTextFormField(BuildContext context, TextEditingController controller,
    String hintText, String labelText,
    {String preText,
    TextInputType textInputType,
    TextStyle textStyle,
    bool capitalise,
    int validationType,
    TextInputFormatter textInputFormatter,
    FocusNode currentFocusNode,
    FocusNode nextFocusNode,
    String prefixText}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: textFormFieldWithoutPadding(context, controller, textInputType,
        textStyle, labelText, hintText, preText,
        capitalise: capitalise,
        validationType: validationType,
        textInputFormatter: textInputFormatter,
        currentFocusNode: currentFocusNode,
        nextFocusNode: nextFocusNode,
        prefixText: prefixText),
  );
}

TextFormField textFormFieldWithoutPadding(
    BuildContext context,
    TextEditingController controller,
    TextInputType textInputType,
    TextStyle textStyle,
    String labelText,
    String hintText,
    String preText,
    {bool capitalise,
    int validationType,
    TextInputFormatter textInputFormatter,
    FocusNode currentFocusNode,
    FocusNode nextFocusNode,
    String prefixText}) {
  return TextFormField(
    focusNode: currentFocusNode != null ? currentFocusNode : null,
    onFieldSubmitted: (term) {
      if (currentFocusNode != null) currentFocusNode.unfocus();
      if (nextFocusNode != null)
        FocusScope.of(context).requestFocus(nextFocusNode);
    },
    controller: controller,
    keyboardType: textInputType ?? TextInputType.text,
    inputFormatters: textInputFormatter != null ? [textInputFormatter] : null,
    textCapitalization: (capitalise ?? false)
        ? TextCapitalization.characters
        : TextCapitalization.none,
    style: textStyle,
    onChanged: (value) {
      if (capitalise ?? false) if (controller.text != value.toUpperCase()) {
        // ReCase rc = new ReCase(value);
        // controller.text = rc.titleCase;
        controller.value = controller.value.copyWith(text: value.toUpperCase());
      }
    },
    validator: (s) => validationType == null
        ? validate(s, labelText)
        : getValidation(s, validationType, labelText),
    decoration:
        inputDecoration(labelText, hintText, preText, controller, prefixText),
  );
}

String getValidation(String s, int validationType, String labelText) {
  switch (validationType) {
    case 2:
      return getPortValidation(s);
      break;
    default:
      return validate(s, labelText);
  }
}

String getPortValidation(String s) {
  return s.isNotEmpty && s == '8124' ? null : "Enter Valid Port Number";
}

InputDecoration inputDecoration(String labelText, String hintText,
    String preText, TextEditingController controller, String prefixText) {
  return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefix: Text(
        preText ?? "",
      ),
      prefixText: prefixText ?? null,
      suffixIcon: inkWell(controller));
}

InkWell inkWell(TextEditingController controller) {
  return InkWell(
      onTap: () => controller.clear(),
      child: Icon(
        Icons.cancel,
        color: Colors.grey,
      ));
}

String validate(String s, String labelText) {
  return s.isNotEmpty ? null : 'Enter Valid $labelText';
}

InputDecorationTheme buildInputDecorationTheme(BuildContext context) {
  return InputDecorationTheme(
    border: new OutlineInputBorder(
        borderSide:
            BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
        borderRadius: getCircularBorderForTextFormField()),
    labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
    hintStyle: TextStyle(
        color: Colors.grey.shade600,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic),
    enabledBorder: OutlineInputBorder(
      borderRadius: getCircularBorderForTextFormField(),
      borderSide: BorderSide(color: Colors.grey, width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: getCircularBorderForTextFormField(),
      borderSide: BorderSide(color: Colors.pinkAccent, width: 2.0),
    ),
  );
}

BorderRadius getCircularBorderForTextFormField() =>
    BorderRadius.all(Radius.circular(15));

Widget getButtonData(IconData iconData, String title, Color color) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Icon(
            iconData,
            color: color,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: PText(
              textKey: title,
              textType: color == Colors.red
                  ? TextType.redButtonText
                  : TextType.whiteButtonText),
        )
      ],
    ),
  );
}

Widget getLogo() {
  return Image.asset("assets/LocationManagementSplash.png");
}

Widget getHeading(String text) {
  return PText(textKey: text, textType: TextType.body1);
}

Future<void> onAboutTapPressed(BuildContext context) async {
  // Navigator.pop(context);

  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
            actions: [
              ButtonBar(
                children: [
                  TextButton(
                    child: PText(
                      textKey: TextConstants.VIEW_LICENSES_IN_DIALOG,
                      textType: TextType.body2,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: PText(
                      textKey: TextConstants.VIEW_LICENSES_IN_DIALOG,
                      textType: TextType.body2,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              )
            ],
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(width: 30, child: getCompanyLogo()),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                            child: Text(
                          "Pinpoint Location Management",
                          softWrap: true,
                        )),
                        Text(
                          "v${packageInfo.version}",
                          style: Theme.of(context).textTheme.caption,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                    child: Text(
                  "2020 XT3ND Software, LLC",
                  style: Theme.of(context).textTheme.subtitle2,
                  softWrap: true,
                )),
              ],
            ),
          ));
}

Image getCompanyLogo() {
  return Image.asset(
    'assets/Logo-CircleX_50px.png',
    alignment: Alignment.centerLeft,
  );
}

void showErrorMessageInSnackBar(BuildContext context, String message,
    GlobalKey<ScaffoldState> _scaffoldKey) {
  _scaffoldKey.currentState.showSnackBar(SnackBar(
    content: Text(
      message,
    ),
    duration: Duration(seconds: 3),
  ));
}

void showDialogForSuccessAndFailureResponse(
    BuildContext context, String title, String contentText, Widget widget) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () => Navigator.pop(context),
              )
            ],
            title: PText(textKey: title, textType: TextType.title),
            content: Row(
              children: [
                widget,
                Flexible(
                    child: PText(
                  textKey: contentText,
                  textType: TextType.body1,
                  // softWrap: true,
                )),
              ],
            ),
          ));
}

String getSuccessText() {
  return TextConstants.SUCCESS_CONTENT_TEXT_IN_DIALOG;
}

String getFailureText() {
  return TextConstants.FAILURE_CONTENT_TEXT_IN_DIALOG;
}

Icon getSuccessIcon() {
  return Icon(
    Icons.check,
    size: 80,
    color: Colors.green,
  );
}

Transform getCrossIcon() {
  return Transform.rotate(
      angle: -math.pi / 4,
      child: Icon(
        Icons.add_rounded,
        color: Colors.red,
        size: 80,
      ));
}

Widget getAppBar(String textKey) {
  return AppBar(
    title: PText(
      textType: TextType.appBar,
      textKey: textKey,
    ),
  );
}

void navigateToSplashScreen(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => SplashScreen(),
    ),
    (route) => false,
  );
}

Widget getDefaultLoading() {
  return Center(
    child: CircularProgressIndicator(),
  );
}

void navigateToHomeScreen(BuildContext context, List<UserTaskModel> list) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => HomeScreen(
        loginResponse: list,
      ),
    ),
    (route) => false,
  );
}

void navigateToLoginScreen(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => LoginScreen(),
    ),
    (route) => false,
  );
}

void navigateToConfigurationSettingsScreen(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfigurationSettingsScreen(),
      ));
}

void navigateToBarCodeScannerScreen(
    BuildContext context, UserTaskModel userTaskModel) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BarCodeScannerScreen(userTaskModel),
      ));
}

void navigateToMiscellaneousScreen(
    BuildContext context, UserTaskModel userTaskModel) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MiscellaneousReceiptScreen(userTaskModel),
      ));
}

void navigateToSalesDeliveryScreen(
    BuildContext context, UserTaskModel userTaskModel) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SalesDeliveryScreen(userTaskModel),
      ));
}

void navigateToPurchaseOrderReceiptScreen(
    BuildContext context, UserTaskModel userTaskModel) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PurchaseOrderReceipt(userTaskModel),
      ));
}

void navigateToInquiryScreen(
    BuildContext context, UserTaskModel userTaskModel) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InquiryScreen(userTaskModel),
      ));
}

void initialNavigateToConfigurationSettingsScreen(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => ConfigurationSettingsScreen(),
    ),
    (route) => false,
  );
}

Widget getNoDataWidget() {
  return Center(
    child: Text("No Data"),
  );
}

Widget getFlatButton(void Function() onPressed, Widget child) {
  return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlatButton(
          minWidth: 150,
          color: Colors.red,
          onPressed: onPressed,
          child: child));
}

Widget getOutLineButton(void Function() onPressed, Widget child) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: OutlineButton(
        borderSide: BorderSide(color: Colors.red),
        onPressed: onPressed,
        child: child),
  );
}

ProgressDialog getProgressDialog(BuildContext context) {
  return new ProgressDialog(
    context,
    isDismissible: false,
    customBody: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
      backgroundColor: Colors.white,
    ),
  );
}

double getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

void navigateToStockChangeScreen(
    BuildContext context, UserTaskModel userTaskModel) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StockExchangeScreen(userTaskModel),
      ));
}

ListTile buildListTileForDrawer(String title, Function() onTapped) {
  return ListTile(
    trailing: Icon(Icons.arrow_right),
    title: PText(
      textKey: title,
      textType: TextType.body2,
    ),
    onTap: onTapped,
  );
}

Container getDrawerHeader() {
  return Container(
    height: 100,
    child: DrawerHeader(
      child: Row(
        children: [
          getCompanyLogo(),
          SizedBox(
            width: 10,
          ),
          Text(
            "Menu",
            style: const TextStyle(
              fontSize: 28,
              color: Colors.white60,
            ),
          )
        ],
      ),
      decoration: BoxDecoration(color: Colors.red.shade300),
    ),
  );
}
