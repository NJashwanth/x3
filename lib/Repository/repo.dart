import 'package:x3/BarcodeScanScreen/Model/BarcodeScannerGridModel.dart';
import 'package:x3/ConfigurationScreen/model/configurationSettingsModel.dart';
import 'package:x3/Login/model/LoginResponse.dart';
import 'package:x3/Login/model/userModel.dart';
import 'package:x3/Repository/Sources/LocalSource/localSource.dart';
import 'package:x3/Repository/Sources/RemoteSource/httpSource.dart';
import 'package:x3/Splash/model/LoginState.dart';

class Repo {
  static Repo _instance;
  final HttpSource httpSource = HttpSource.getInstance();
  final LocalSource _localSource = LocalSource.getInstance();

  static Repo getInstance() {
    if (_instance == null) _instance = new Repo();
    return _instance;
  }

  Future<LoginState> getAppState() async {
    ConfigurationSettings savedSettings = await _localSource.getConfiguration();
    if (savedSettings.server == null) {
      print("Server is null");
      return LoginState.newState();
    } else {
      return LoginState.savedSettings();
    }
  }

  Stream<TextConfiguration> getTextConfiguration() {
    return _localSource.getTextConfiguration();
  }

  Future<int> sendUBEntries(List<BarCodeGridModel> ubEntries) async {
    ConfigurationSettings settings = await _localSource.getConfiguration();
    return await httpSource.createUB(ubEntries, settings);
  }

  void setLanguage(String language) {
    print("setLanguage in repo");
    return _localSource.setLanguage(language);
  }

  getStockDetails() async {
    ConfigurationSettings configurationSettings =
        await _localSource.getConfiguration();
    return httpSource.getStockDetails(configurationSettings);
  }

  void setIncrementer(int incrementer) {
    return _localSource.setIncrementer(incrementer);
  }

  Future<String> testConnection(
      ConfigurationSettings configurationSettings) async {
    return await httpSource.testConnection(configurationSettings);
  }

  Future<String> saveConfiguration(
      ConfigurationSettings configurationSettings) async {
    String response = await testConnection(configurationSettings);
    if (response == "Success") {
      await _localSource.saveConfiguration(configurationSettings);
      return "Success";
    } else {
      return response;
    }
  }

  Future<LoginResponse> login(UserModel userModel) async {
    ConfigurationSettings savedSettings = await _localSource.getConfiguration();
    return await httpSource.login(userModel, savedSettings);
  }

  Future<ConfigurationSettings> getConfiguration() {
    return _localSource.getConfiguration();
  }

  int getIncrementer() {
    return _localSource.getIncrementer();
  }
}
