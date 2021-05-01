import 'package:flutter/material.dart';
import 'package:x3/utils/utils.dart';

class DrawerInAppBar extends StatefulWidget {
  @override
  _DrawerInAppBarState createState() => _DrawerInAppBarState();
}

class _DrawerInAppBarState extends State<DrawerInAppBar> {
  double _currentSliderValue = 1;

  @override
  Widget build(BuildContext context) {
    return getDrawer(context);
  }

  Widget getDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                getDrawerHeader(),
                buildListTileForDrawer("X3 Configurations Settings",
                    () => navigateToConfigurationSettingsScreen(context)),
                buildListTileForDrawer(
                    "About", () => onAboutTapPressed(context)),
                getRadioButtonsForLanguage(),
                getSliderForTextSizes(),
              ],
            ),
          ),
          buildListTileForDrawer(
              "Logout", () => navigateToLoginScreen(context)),
        ],
      ),
    );
  }

  Widget getSliderForTextSizes() {
    return ListTile(
      title: getHeading("Text Size"),
      subtitle: Slider(
        value: _currentSliderValue,
        min: -10,
        max: 10,
        divisions: 10,
        label: _currentSliderValue.round().toString(),
        onChanged: (double value) {
          setState(() {
            _currentSliderValue = value;
          });
        },
      ),
    );
  }

  Widget getRadioButtonsForLanguage() {
    int group = 0;
    return ListTile(
        title: getHeading("Language"),
        subtitle: Row(
          children: [
            Radio<int>(onChanged: (value) {}, value: 0, groupValue: group),
            Text("English"),
            Radio<int>(onChanged: (value) {}, value: 1, groupValue: group),
            Text("Spanish"),
          ],
        ));
  }
}
