import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:x3/ConfigurationScreen/model/configurationSettingsModel.dart';
import 'package:x3/Login/model/LoginResponse.dart';
import 'package:x3/Login/model/userModel.dart';
import 'package:x3/Repository/repo.dart';
import 'package:x3/Splash/model/EnumForStateManagement.dart';

class SplashBloc {
  static SplashBloc _instance;

  BehaviorSubject<LoginStates> state = new BehaviorSubject();

  LoginResponse loginResponse;

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
    state.add(LoginStates.splash);

    await Hive.openBox('configuration');
    await Hive.openBox('login');
    bool isServerConfigWorking = Hive.box("configuration").get("isConfigured");
    print("isServerConfigWorking $isServerConfigWorking");
    if (isServerConfigWorking != null && isServerConfigWorking) {
      bool isLoggedIn = Hive.box("login").get("isLoggedIn");
      if (isLoggedIn != null && isLoggedIn) {
      } // state.add(LoginStates.home);
      else
        state.add(LoginStates.login);
    } else
      state.add(LoginStates.configurationSettings);
  }

  Future<String> testConfigurations(
      ConfigurationSettings configurationSettings) async {
    // state.add(LoginStates.loading);
    return await _repo.testConnection(configurationSettings);
  }

  Future<void> saveConfigurations(
      ConfigurationSettings configurationSettingsModel) async {
    state.add(LoginStates.loading);

    String responseFromServer =
        await _repo.testConnection(configurationSettingsModel);
    if (responseFromServer == "Success") {
      state.add(LoginStates.login);
    } else {
      state.add(LoginStates.errorInConfigure);
    }
  }

  Future<LoginResponse> login(UserModel userModel) async {
    state.add(LoginStates.loading);

    loginResponse = await _repo.login(
      userModel,
    );

    if (loginResponse.isSuccess) {
      state.add(LoginStates.home);
    }
  }
}
