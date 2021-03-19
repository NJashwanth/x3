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

  String get(String textKey) {
    String language =
        Hive.box('settings').get("language", defaultValue: "Not fount");
    return texts["$language-$textKey"];
  }
}
