import 'package:rxdart/rxdart.dart';
import 'package:x3/Repository/repo.dart';
import 'package:x3/StockChangeScreen/model/StockExchangeGridModel.dart';

class StockChangeBloc {
  static StockChangeBloc _instance;
  Repo _repo = Repo.getInstance();

  static StockChangeBloc getInstance() {
    if (_instance == null) _instance = new StockChangeBloc();
    return _instance;
  }

  // ignore: close_sinks
  BehaviorSubject<StockExchangeGridModel> _listOfGridController =
      new BehaviorSubject();

  Stream<StockExchangeGridModel> get listOfGridStream =>
      _listOfGridController.stream;

  getEntriesWithDocumentId() {}

  Future<StockExchangeGridModel> getGridDataForStockExchange(
      String documentNumber) async {
    try {
      Map<dynamic, dynamic> mapFromServer = await _repo.getStockDetails();
      print("mapFromServer = $mapFromServer");
      return StockExchangeGridModel.fromJson(mapFromServer['RESULT']);
    } catch (e) {
      print("Error in parsing getGridDataForStockExchange = $e");
      return null;
    }
  }

  void updateStreamList(StockExchangeGridModel list) {
    _listOfGridController.add(list);
  }
}
