import 'package:x3/ConfigurationScreen/model/configurationSettingsModel.dart';
import 'package:x3/Repository/Sources/httpSource.dart';

class Repo {
  static Repo _instance;
  final HttpSource httpSource = HttpSource.getInstance();

  static Repo getInstance() {
    if (_instance == null) _instance = new Repo();
    return _instance;
  }

  dynamic testConnection(ConfigurationSettings configurationSettings) {
    return httpSource.testConnection(configurationSettings);
  }
}
