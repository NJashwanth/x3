import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class TextConstants {
  static const HOMESCREEN_APPBAR_TITLE = "HOMESCREEN_APPBAR_TITLE";
  static const LOGINSCREEN_APPBAR_TITLE = "LOGINSCREEN_APPBAR_TITLE";
  static const CONFIGURATION_APPBAR_TITLE = "CONFIGURATION_APPBAR_TITLE";
  static const WEBSERVICES_TEXT = "WEBSERVICES_TEXT";
  static const TEXT_SIZE_HEADING_IN_DRAWER = "TEXT_SIZE_HEADING_IN_DRAWER";
  static const LANGUAGE_HEADING_IN_DRAWER = "LANGUAGE_HEADING_IN_DRAWER";
  static const LOGIN_TEXT = "LOGIN_TEXT";
  static const VIEW_LICENSES_IN_DIALOG = "VIEW_LICENSES_IN_DIALOG";
  static const CLOSE_TEXT_IN_DIALOG = "CLOSE_TEXT_IN_DIALOG";
  static const CONFIGURATION_SETTINGS_IN_DRAWER =
      "CONFIGURATION_SETTINGS_IN_DRAWER";
  static const ABOUT_IN_DRAWER = "ABOUT_IN_DRAWER";
  static const LOGOUT_IN_DRAWER = "LOGOUT_IN_DRAWER";
  static const CHECKING_CONFIGURATIONS_IN_SPLASH =
      "CHECKING_CONFIGURATIONS_IN_SPLASH";
  static const TEST_CONNECTION_BUTTON_NAME = "TEST_CONNECTION_BUTTON_NAME";
  static const SAVE_BUTTON_NAME = "SAVE_BUTTON_NAME";
  static const LOGIN_BUTTON_NAME = "LOGIN_BUTTON_NAME";

  static const SEND_BUTTON_NAME = "SEND_BUTTON_NAME";
  static const CLEAR_BUTTON_NAME = "CLEAR_BUTTON_NAME";

  static const SUCCESS_TEXT_IN_DIALOG = "SUCCESS_TEXT_IN_DIALOG";
  static const FAILURE_TEXT_IN_DIALOG = "FAILURE_TEXT_IN_DIALOG";
  static const SUCCESS_CONTENT_TEXT_IN_DIALOG =
      "SUCCESS_CONTENT_TEXT_IN_DIALOG";
  static const FAILURE_CONTENT_TEXT_IN_DIALOG =
      "FAILURE_CONTENT_TEXT_IN_DIALOG";

  Map<String, String> texts = new Map();

  static TextConstants instance;

  static TextConstants getInstance() {
    if (instance == null) instance = new TextConstants();
    return instance;
  }

  TextConstants() {
    texts["ENG-login"] = "Login";
    texts["fn-login"] = "LoginF";
    texts['$HOMESCREEN_APPBAR_TITLE-ENG'] = 'Choose a Task';
    texts['$HOMESCREEN_APPBAR_TITLE-fn'] = 'Choose a Task';
    texts['$LOGINSCREEN_APPBAR_TITLE-ENG'] = 'Login';
    texts['$CONFIGURATION_APPBAR_TITLE-ENG'] = "Configurations Settings";
    texts['$WEBSERVICES_TEXT-ENG'] = "WEB SERVICES SETTINGS";
    texts['$TEXT_SIZE_HEADING_IN_DRAWER-ENG'] = "Text Size";
    texts['$LANGUAGE_HEADING_IN_DRAWER-ENG'] = "Language";
    texts['$LOGIN_TEXT-ENG'] = "LOGIN";
    texts['$VIEW_LICENSES_IN_DIALOG-ENG'] = "VIEW LICENSES";
    texts['$CLOSE_TEXT_IN_DIALOG-ENG'] = "CLOSE";
    texts['$CONFIGURATION_SETTINGS_IN_DRAWER-ENG'] =
        "X3 Configurations Settings";
    texts['$ABOUT_IN_DRAWER-ENG'] = "About";
    texts['$LOGOUT_IN_DRAWER-ENG'] = "Logout";
    texts['$CHECKING_CONFIGURATIONS_IN_SPLASH-ENG'] = "Checking Configuration";
    texts['$TEST_CONNECTION_BUTTON_NAME-ENG'] = "Test Connection";
    texts['$SAVE_BUTTON_NAME-ENG'] = "Save";
    texts['$LOGIN_BUTTON_NAME-ENG'] = "Login";
    texts['$SUCCESS_TEXT_IN_DIALOG-ENG'] = "Success";
    texts['$FAILURE_TEXT_IN_DIALOG-ENG'] = "Error";
    texts['$SUCCESS_CONTENT_TEXT_IN_DIALOG-ENG'] =
        "You've successfully connected to Sage X3. If you would like to use these credentials, please press the Save button";
    texts['$FAILURE_CONTENT_TEXT_IN_DIALOG-ENG'] =
        "The server has report an undefined error. The most likely cause is an incorrect Folder and/or Language value in the application setup. Please contact your administrator";
    texts['$SEND_BUTTON_NAME-ENG'] = "Send";
    texts['$CLEAR_BUTTON_NAME-ENG'] = "Clear Screen";
  }

  Future<bool> load() async {
    String language = Hive.box('settings').get("language", defaultValue: "en");
    // Load the language JSON file from the "lang" folder
    final String jsonString =
        await rootBundle.loadString('lang/$language.json');
    final Map<String, dynamic> jsonMap =
        json.decode(jsonString) as Map<String, dynamic>;

    texts = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  Future<String> get(String textKey, String language) async {
    print("Get called with $textKey");

    print("Text Key is $textKey-$language");
    print("Text Key is " + texts.containsKey("$textKey-$language").toString());
    return texts["$textKey-$language"];
  }
}
