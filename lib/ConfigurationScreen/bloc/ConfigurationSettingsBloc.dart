import 'package:x3/ConfigurationScreen/model/configurationSettingsModel.dart';
import 'package:x3/Repository/repo.dart';

class ConfigurationSettingsBloc {
  static ConfigurationSettingsBloc _instance;
  Repo _repo = Repo.getInstance();

  static ConfigurationSettingsBloc getInstance() {
    return _instance ?? new ConfigurationSettingsBloc();
  }

  dynamic testConfigurations(ConfigurationSettings configurationSettings) {
    return _repo.testConnection(configurationSettings);
  }

  void saveConfigurations(ConfigurationSettings configurationSettingsModel) {}
}
