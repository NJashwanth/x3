class AppBloc {
  static AppBloc instance;

  static AppBloc getInstance() {
    if (instance == null) instance = new AppBloc();
    return instance;
  }
}
