import 'package:x3/Repository/repo.dart';

class StockChangeBloc {
  static StockChangeBloc _instance;
  Repo _repo = Repo.getInstance();

  static StockChangeBloc getInstance() {
    if (_instance == null) _instance = new StockChangeBloc();
    return _instance;
  }
}
