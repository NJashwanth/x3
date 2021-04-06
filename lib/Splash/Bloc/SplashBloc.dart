import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:x3/ConfigurationScreen/model/configurationSettingsModel.dart';
import 'package:x3/Login/model/userModel.dart';
import 'package:x3/Repository/repo.dart';
import 'package:x3/Splash/model/EnumForStateManagement.dart';

class SplashBloc {
  static SplashBloc _instance;

  BehaviorSubject<LoginStates> state = new BehaviorSubject();

  Stream<LoginStates> get stateStream => state.stream;

  Repo _repo = Repo.getInstance();

  static SplashBloc getInstance() {
    if (_instance == null) _instance = new SplashBloc();
    return _instance;
  }

  SplashBloc() {
    checkState();
  }

  Future<void> checkState() async {
    await Hive.openBox('configuration');
    await Hive.openBox('login');
    bool isServerConfigWorking = Hive.box("configuration").get("isConfigured");
    print("isServerConfigWorking $isServerConfigWorking");
    if (isServerConfigWorking != null && isServerConfigWorking) {
      bool isLoggedIn = Hive.box("login").get("isLoggedIn");
      if (isLoggedIn != null && isLoggedIn)
        state.add(LoginStates.home);
      else
        state.add(LoginStates.login);
    } else
      state.add(LoginStates.configurationSettings);
  }

  Future<String> testConfigurations(
      ConfigurationSettings configurationSettings) async {
    state.add(LoginStates.loading);
    return await _repo.testConnection(configurationSettings);
  }

  void saveConfigurations(ConfigurationSettings configurationSettingsModel) {}

  Future<String> login(UserModel userModel) async {
    // state.add(LoginStates.loading);

    return await _repo.login(userModel);
  }
}
