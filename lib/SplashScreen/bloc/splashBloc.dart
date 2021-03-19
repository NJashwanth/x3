class SplashBloc {
  static SplashBloc instance;

  static SplashBloc getInstance() {
    if (instance == null) instance = new SplashBloc();
    return instance;
  }
}
