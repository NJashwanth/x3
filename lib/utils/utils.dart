import 'package:flutter/material.dart';

Widget getTextFormField(
    TextEditingController controller, String hintText, String labelText,
    {String preText, TextInputType textInputType, TextStyle textStyle}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      controller: controller,
      keyboardType: textInputType ?? TextInputType.text,
      style: textStyle,
      validator: (s) => validate(s),
      decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefix: Text(
            preText ?? "",
          ),
          suffixIcon: InkWell(
              onTap: () => controller.clear(),
              child: Icon(
                Icons.cancel,
                color: Colors.grey,
              ))),
    ),
  );
}

String validate(String s) {
  return s.isNotEmpty ? null : 'Enter Valid Details';
}

InputDecorationTheme buildInputDecorationTheme() {
  return InputDecorationTheme(
    border: new OutlineInputBorder(),
    labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
    hintStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
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
      padding: EdgeInsets.all(0),
      children: [
        DrawerHeader(
          child: Text(
            'X3',
          ),
          decoration: BoxDecoration(color: Colors.red.shade50),
        ),
        ListTile(
          trailing: Icon(Icons.arrow_right),
          title: Text(
            'X3 Configurations Settings',
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
