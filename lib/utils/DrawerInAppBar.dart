import 'package:flutter/material.dart';
import 'package:x3/utils/Bloc/DrawerBLoc.dart';
import 'package:x3/utils/textConstants.dart';
import 'package:x3/utils/utils.dart';

class DrawerInAppBar extends StatefulWidget {
  @override
  _DrawerInAppBarState createState() => _DrawerInAppBarState();
}

class _DrawerInAppBarState extends State<DrawerInAppBar> {
  double _currentSliderValue = 1;
  DrawerBloc _bloc = DrawerBloc.getInstance();
  String group = "ENG";

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
                buildListTileForDrawer(
                    TextConstants.CONFIGURATION_SETTINGS_IN_DRAWER,
                    () => navigateToConfigurationSettingsScreen(context)),
                buildListTileForDrawer(TextConstants.ABOUT_IN_DRAWER,
                    () => onAboutTapPressed(context)),
                getRadioButtonsForLanguage(),
                getSliderForTextSizes(),
              ],
            ),
          ),
          buildListTileForDrawer(TextConstants.LOGOUT_IN_DRAWER,
              () => navigateToLoginScreen(context)),
        ],
      ),
    );
  }

  Widget getSliderForTextSizes() {
    return ListTile(
      title: getHeading(TextConstants.TEXT_SIZE_HEADING_IN_DRAWER),
      subtitle: Slider(
        value: _currentSliderValue,
        min: -10,
        max: 10,
        divisions: 10,
        label: _currentSliderValue.round().toString(),
        onChanged: (double value) {
          setState(() {
            _currentSliderValue = value;
            _bloc.setIncrementer(value);
          });
        },
      ),
    );
  }

  Widget getRadioButtonsForLanguage() {
    return ListTile(
        title: getHeading(TextConstants.LANGUAGE_HEADING_IN_DRAWER),
        subtitle: Row(
          children: [
            Radio<String>(
                onChanged: (value) {
                  changeCurrentLanguage(value);
                },
                value: "ENG",
                groupValue: group),
            Text("English"),
            Radio<String>(
                onChanged: (value) {
                  changeCurrentLanguage(value);
                },
                value: 'es',
                groupValue: group),
            Text("Spanish"),
          ],
        ));
  }

  void changeCurrentLanguage(String value) {
    return setState(() {
      group = value;
      _bloc.setLanguage(value);
    });
  }
}
