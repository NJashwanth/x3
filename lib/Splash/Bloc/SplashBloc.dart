class SplashBloc {
  static SplashBloc _instance;

  static SplashBloc getInstance() {
    if (_instance == null) _instance = new SplashBloc();
    return _instance;
  }
}
