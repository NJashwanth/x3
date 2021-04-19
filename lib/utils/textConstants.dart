import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class TextConstants {
  Map<String, String> texts = new Map();

  static TextConstants instance;

  static TextConstants getInstance() {
    if (instance == null) instance = new TextConstants();
    return instance;
  }

  TextConstants() {
    texts["eng-login"] = "Login";
    texts["fnc-login"] = "LoginF";
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

  Future<String> get(String textKey, String lamguage) async {
    await load();
    print("Text Key is $textKey");
    return texts["$textKey"];
  }
}
