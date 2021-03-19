import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:x3/Splash/model/EnumForStateManagement.dart';

class SplashBloc {
  static SplashBloc _instance;

  BehaviorSubject<LoginStates> state = new BehaviorSubject();

  Stream<LoginStates> get stateStream => state.stream;

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

    state.add(LoginStates.loading);
    bool isServerConfigWorking = Hive.box("configuration").get("isConfigured");
    if (isServerConfigWorking != null && isServerConfigWorking) {
      bool isLoggedIn = Hive.box("login").get("isLoggedIn");
      if (isLoggedIn != null && isLoggedIn)
        state.add(LoginStates.home);
      else
        state.add(LoginStates.login);
    } else
      state.add(LoginStates.configurationSettings);
  }
}
