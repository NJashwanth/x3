import 'package:rxdart/rxdart.dart';
import 'package:x3/Repository/repo.dart';
import 'package:x3/Splash/model/LoginState.dart';

class SplashBloc {
  static SplashBloc _instance;

  BehaviorSubject<LoginState> loginStateController = new BehaviorSubject();

  Stream<LoginState> get loginStateStream => loginStateController.stream;

  Repo _repo = Repo.getInstance();

  static SplashBloc getInstance() {
    if (_instance == null) _instance = new SplashBloc();
    return _instance;
  }

  SplashBloc() {
    print("check state in Splash block");
    checkState();
    loginStateController.stream.listen((event) => onChange(event));
  }

  Future<void> checkState() async {
    loginStateController.add(LoginState.splash());
    LoginState loginState = await _repo.getAppState();
    loginStateController.add(loginState);
  }

  void clear() {
    _instance = null;
  }

  void onChange(LoginState event) {
    print("Current Login State  = ${event.lState}");
  }
}
