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
import 'package:x3/Repository/Sources/RemoteSource/httpSource.dart';
import 'package:x3/Repository/repo.dart';

void main() {
  var workingConfigurationSettings = new ConfigurationSettings(
      folder: "GITAPP",
      server: "http://sagex3v12.germinit.com",
      port: "8124",
      language: "ENG",
      password: "admin",
      userName: "admin");

  test('IsTestConnectionReturningSuccessWithValidConfiguration', () async {
    // Build our app and trigger a frame.
    Repo repo = Repo.getInstance();
    String a = await repo.testConnection(workingConfigurationSettings);
    expect(a, "Success");
  });

  test('Auth header test', () {
    HttpSource httpSource = HttpSource.getInstance();
    expect(httpSource.getAuthorization("admin", "admin"),
        "Basic YWRtaW46YWRtaW4=");
  });

  test('Login Test without config', () async {
    // Build our app and trigger a frame.
    Repo repo = Repo.getInstance();
    LoginResponse loginResponse =
        await repo.login(new UserModel("USR01", "USR01"));
    expect(loginResponse.isSuccess, false);
  });

  test("Configuration saved", () async {
    Repo repo = Repo.getInstance();
    await repo.saveConfiguration(workingConfigurationSettings);
    ConfigurationSettings configurationSettingsSaved = repo.getConfiguration();
    expect(
        configurationSettingsSaved.server, workingConfigurationSettings.server);
    expect(
        configurationSettingsSaved.folder, workingConfigurationSettings.folder);
    expect(configurationSettingsSaved.userName,
        workingConfigurationSettings.userName);
    expect(configurationSettingsSaved.language,
        workingConfigurationSettings.language);
    expect(configurationSettingsSaved.password,
        workingConfigurationSettings.password);

    expect(configurationSettingsSaved.port, workingConfigurationSettings.port);
  });

  test('Login Test with config', () async {
    // Build our app and trigger a frame.
    Repo repo = Repo.getInstance();
    await repo.testConnection(workingConfigurationSettings);
    LoginResponse loginResponse =
        await repo.login(new UserModel("USR01", "USR01"));
    expect(loginResponse.isSuccess, false);
  });
}
