class StockChangeBloc {
  static StockChangeBloc _instance;

  static StockChangeBloc getInstance() {
    if (_instance == null) _instance = new StockChangeBloc();
    return _instance;
  }
}
