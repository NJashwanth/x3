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
}
