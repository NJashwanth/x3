import 'package:x3/ConfigurationScreen/model/configurationSettingsModel.dart';

class ConfigurationSettingsBloc {
  static ConfigurationSettingsBloc _instance;

  static ConfigurationSettingsBloc getInstance() {
    return _instance ?? new ConfigurationSettingsBloc();
  }

  void testConfigurations(
      ConfigurationSettingsModel configurationSettingsModel) {}

  void saveConfigurations(
      ConfigurationSettingsModel configurationSettingsModel) {}
}
