import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:x3/ConfigurationScreen/ui/ConfigurationSettingsScreen.dart';
import 'package:x3/HomeScreen/ui/homeScreen.dart';
import 'package:x3/Login/ui/loginScreen.dart';
import 'package:x3/Splash/splashScreen.dart';

Widget getTextFormField(
    TextEditingController controller, String hintText, String labelText,
    {String preText,
    TextInputType textInputType,
    TextStyle textStyle,
    bool capitalise}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: textFormFieldWithoutPadding(
        controller, textInputType, textStyle, labelText, hintText, preText,
        capitalise: capitalise),
  );
}

TextFormField textFormFieldWithoutPadding(
    TextEditingController controller,
    TextInputType textInputType,
    TextStyle textStyle,
    String labelText,
    String hintText,
    String preText,
    {bool capitalise}) {
  return TextFormField(
    controller: controller,
    keyboardType: textInputType ?? TextInputType.text,
    textCapitalization: (capitalise ?? false)
        ? TextCapitalization.characters
        : TextCapitalization.none,
    style: textStyle,
    validator: (s) => validate(s),
    decoration: inputDecoration(labelText, hintText, preText, controller),
  );
}

InputDecoration inputDecoration(String labelText, String hintText,
    String preText, TextEditingController controller) {
  return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      hintStyle: TextStyle(fontStyle: FontStyle.italic),
      prefix: Text(
        preText ?? "",
      ),
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

String validate(String s) {
  return s.isNotEmpty ? null : 'Enter Valid Details';
}

InputDecorationTheme buildInputDecorationTheme() {
  return InputDecorationTheme(
    border: new OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15))),
    labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
    hintStyle: TextStyle(
        color: Colors.grey.shade600,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.pinkAccent, width: 1.0),
    ),
  );
}

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
          child: Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        )
      ],
    ),
  );
}

Widget getLogo() {
  return Container(
    child: Image.asset("assets/LocationManagementSplash.png"),
  );
}

Widget getHeading(String text) {
  return Text(
    text,
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  );
}

Widget getDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
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
        ),
        ListTile(
          trailing: Icon(Icons.arrow_right),
          title: Text(
            'X3 Configurations Settings',
          ),
          onTap: () => navigateToConfigurationSettingsScreen(context),
        ),
        ListTile(
          trailing: Icon(Icons.arrow_right),
          title: Text(
            'About',
          ),
          // onTap: () => navigateToConfigurationSettingsScreen(context),
        ),
      ],
    ),
  );
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
            title: Text(title),
            content: Row(
              children: [
                widget,
                Flexible(
                    child: Text(
                  contentText,
                  softWrap: true,
                )),
              ],
            ),
          ));
}

String getSuccessText() {
  return "You've successfully connected to Sage X3. If you would like to use these credentials, please press the Save button";
}

String getFailureText() {
  return "The server has report an undefined error. The most likely cause is an incorrect Folder and/or Language value in the application setup. Please contact your administrator";
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

Widget getAppBar(String title) {
  return AppBar(
    title: Text(
      title,
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

void navigateToHomeScreen(BuildContext context, List<String> list) {
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

Widget getNoDataWidget() {
  return Center(
    child: Text("No Data"),
  );
}
