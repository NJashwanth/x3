import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class TextConstants {
  static const HOMESCREEN_APPBAR_TITLE = "HOMESCREEN_APPBAR_TITLE";

  Map<String, String> texts = new Map();

  static TextConstants instance;

  static const LOGINSCREEN_APPBAR_TITLE = "LOGINSCREEN_APPBAR_TITLE";

  static TextConstants getInstance() {
    if (instance == null) instance = new TextConstants();
    return instance;
  }

  TextConstants() {
    texts["eng-login"] = "Login";
    texts["fn-login"] = "LoginF";
    texts['$HOMESCREEN_APPBAR_TITLE-eng'] = 'Choose a Task';
    texts['$LOGINSCREEN_APPBAR_TITLE-eng'] = 'Login';
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
    texts.keys.forEach((element) {
      print("$element");
    });
    return texts["$textKey-$language"];
  }
}
