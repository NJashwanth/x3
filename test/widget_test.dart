// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:x3/ConfigurationScreen/model/configurationSettingsModel.dart';
import 'package:x3/Login/model/LoginResponse.dart';
import 'package:x3/Login/model/userModel.dart';
import 'package:x3/Repository/Sources/httpSource.dart';
import 'package:x3/Repository/repo.dart';

void main() {
  test('Auth header test', () {
    HttpSource httpSource = HttpSource.getInstance();
    expect(httpSource.getAuthorization("admin", "admin"),
        "Basic YWRtaW46YWRtaW4=");
  });
  test('Configuration test', () async {
    // Build our app and trigger a frame.
    Repo configurationSettingsBloc = Repo.getInstance();
    String a = await configurationSettingsBloc.testConnection(
        new ConfigurationSettings(
            folder: "GITAPP",
            server: "http://sagex3v12.germinit.com",
            port: "8124",
            language: "ENG",
            password: "admin",
            userName: "admin"));
    expect(a, "Success");
  });

  test('Login Test', () async {
    // Build our app and trigger a frame.
    Repo configurationSettingsBloc = Repo.getInstance();
    LoginResponse loginResponse = await configurationSettingsBloc.login(
        new UserModel("USR01", "USR01"),
        new ConfigurationSettings(
            folder: "GITAPP",
            server: "http://sagex3v12.germinit.com",
            port: "8124",
            language: "ENG",
            password: "admin",
            userName: "admin"));
    expect(loginResponse.isSuccess, true);
  });
}
