import 'package:x3/ConfigurationScreen/model/configurationSettingsModel.dart';
import 'package:x3/Repository/repo.dart';

class ConfigurationSettingsBloc {
  static ConfigurationSettingsBloc _instance;
  Repo _repo = Repo.getInstance();

  static ConfigurationSettingsBloc getInstance() {
    return _instance ?? new ConfigurationSettingsBloc();
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
