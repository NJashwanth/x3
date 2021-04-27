import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:x3/ConfigurationScreen/ui/ConfigurationSettingsScreen.dart';
import 'package:x3/HomeScreen/model/UserTaskModel.dart';
import 'package:x3/HomeScreen/ui/homeScreen.dart';
import 'package:x3/Login/ui/loginScreen.dart';
import 'package:x3/Splash/splashScreen.dart';

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
      if (capitalise ?? false) if (controller.text != value.toUpperCase())
        controller.value = controller.value.copyWith(text: value.toUpperCase());
    },
    validator: (s) => validate(s),
    decoration:
        inputDecoration(labelText, hintText, preText, controller, prefixText),
  );
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

String validate(String s) {
  return s.isNotEmpty ? null : 'Enter Valid Details';
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
  return Image.asset("assets/LocationManagementSplash.png");
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
          onTap: () => onAboutTapPressed(context),
        ),
      ],
    ),
  );
}

void onAboutTapPressed(BuildContext context) {
  Navigator.pop(context);
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
            actions: [
              ButtonBar(
                children: [
                  TextButton(
                    child: Text("VIEW LICENSES"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                    child: Text("CLOSE"),
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
                          "v2.0.0",
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
