import 'package:x3/Repository/repo.dart';

class DrawerBloc {
  static DrawerBloc _instance;
  Repo _repo = Repo.getInstance();

  static DrawerBloc getInstance() {
    if (_instance == null) _instance = new DrawerBloc();
    return _instance;
  }

  void setLanguage(String language) {
    print("setLanguage in Drawer Bloc");
    _repo.setLanguage(language);
  }
}
