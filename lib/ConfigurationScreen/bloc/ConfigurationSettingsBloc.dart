import 'package:rxdart/rxdart.dart';
import 'package:x3/ConfigurationScreen/model/configurationSettingsModel.dart';
import 'package:x3/Repository/repo.dart';

class ConfigurationSettingsBloc {
  static ConfigurationSettingsBloc _instance;
  Repo _repo = Repo.getInstance();

  BehaviorSubject<bool> loadingController = new BehaviorSubject();

  Stream<bool> get loadingStream => loadingController.stream;

  static ConfigurationSettingsBloc getInstance() {
    if (_instance == null) _instance = new ConfigurationSettingsBloc();
    return _instance;
  }

  Future<String> testConfigurations(
      ConfigurationSettings configurationSettings) async {
    return await _repo.testConnection(configurationSettings);
  }

  Future<String> saveConfigurations(
      ConfigurationSettings configurationSettingsModel) async {
    return await _repo.testConnection(configurationSettingsModel);
  }
}
