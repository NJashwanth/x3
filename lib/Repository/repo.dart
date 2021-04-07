import 'package:hive/hive.dart';
import 'package:x3/ConfigurationScreen/model/configurationSettingsModel.dart';
import 'package:x3/Login/model/LoginResponse.dart';
import 'package:x3/Login/model/userModel.dart';
import 'package:x3/Repository/Sources/LocalSource/localSource.dart';
import 'package:x3/Repository/Sources/RemoteSource/httpSource.dart';
import 'package:x3/Splash/model/LoginState.dart';

class Repo {
  static Repo _instance;
  final HttpSource httpSource = HttpSource.getInstance();
  LocalSource _localSource = LocalSource.getInstance();

  static Repo getInstance() {
    if (_instance == null) _instance = new Repo();
    return _instance;
  }

  Future<LoginState> getAppState() async {
    ConfigurationSettings savedSettings = await _localSource.getConfiguration();
    if (savedSettings.server == null) {
      return LoginState.newState();
    } else {
      return LoginState.savedSettings();
    }
  }

  Stream<String> getLanguage() {
    return _localSource.getLanguage();
  }

  Future<String> testConnection(
      ConfigurationSettings configurationSettings) async {
    return await httpSource.testConnection(configurationSettings);
  }

  Future<bool> saveConfiguration(
      ConfigurationSettings configurationSettings) async {
    if (await testConnection(configurationSettings) == "Success") {
      await _localSource.saveConfiguration(configurationSettings);
      return true;
    } else {
      return false;
    }
  }

  Future<LoginResponse> login(UserModel userModel) async {
    ConfigurationSettings savedSettings = new ConfigurationSettings();
    savedSettings.language = Hive.box("configuration").get("language");
    savedSettings.folder = Hive.box("configuration").get("folder");
    savedSettings.password = Hive.box("configuration").get("password");
    savedSettings.userName = Hive.box("configuration").get("userName");
    savedSettings.port = Hive.box("configuration").get("port");
    savedSettings.server = Hive.box("configuration").get("server");
    return await httpSource.login(userModel, savedSettings);
  }

  Future<ConfigurationSettings> getConfiguration() {
    return _localSource.getConfiguration();
  }
}
