import 'package:x3/ConfigurationScreen/model/configurationSettingsModel.dart';
import 'package:x3/Login/model/userModel.dart';
import 'package:x3/Repository/Sources/httpSource.dart';

class Repo {
  static Repo _instance;
  final HttpSource httpSource = HttpSource.getInstance();

  static Repo getInstance() {
    if (_instance == null) _instance = new Repo();
    return _instance;
  }

  Future<String> testConnection(
      ConfigurationSettings configurationSettings) async {
    return await httpSource.testConnection(configurationSettings);
  }

  Future<String> login(UserModel userModel) async {
    return await httpSource.login(userModel);
  }
}
