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
    ConfigurationSettings savedSettings = new ConfigurationSettings();
    savedSettings.server = Hive.box("configuration").get("server");

    if (savedSettings.server == null) {
      return LoginState.newState();
    } else {
      return LoginState.savedSettings();
    }
  }

  Future<String> testConnection(
      ConfigurationSettings configurationSettings) async {
    return await httpSource.testConnection(configurationSettings);
  }

  Future saveConfiguration(ConfigurationSettings configurationSettings) async {
    if (await testConnection(configurationSettings) == "Success") {
      Hive.box("configuration").put("isConfigured", true);
      Hive.box("configuration").put("server", configurationSettings.server);
      Hive.box("configuration").put("port", configurationSettings.port);
      Hive.box("configuration").put("userName", configurationSettings.userName);
      Hive.box("configuration").put("password", configurationSettings.password);
      Hive.box("configuration").put("folder", configurationSettings.folder);
      Hive.box("configuration").put("language", configurationSettings.language);
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
}
