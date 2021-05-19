import 'package:rxdart/rxdart.dart';
import 'package:x3/Repository/repo.dart';
import 'package:x3/StockChangeScreen/model/StockExchangeGridModel.dart';
import 'package:x3/StockChangeScreen/model/StockTransacionRequest.dart';

class StockChangeBloc {
  static StockChangeBloc _instance;
  Repo _repo = Repo.getInstance();

  static StockChangeBloc getInstance() {
    if (_instance == null) _instance = new StockChangeBloc();
    return _instance;
  }

  // ignore: close_sinks
  BehaviorSubject<List<Stock>> _listOfGridController = new BehaviorSubject();

  Stream<List<Stock>> get listOfGridStream => _listOfGridController.stream;

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

  void updateStreamList(List<Stock> list) {
    _listOfGridController.add(list);
  }

  List<Stock> getStocksList() {
    List<Stock> listToReturn = [];
    for (int i = 0; i < 10; i++) {
      Stock stock = new Stock(
          yXITMREF: "Random$i",
          yXLOC: "Random$i",
          yXLOCTYP: "Random$i",
          yXLOT: "Random$i",
          yXPCU: "Random$i",
          yXQTY: "Random$i",
          yXSTA: "Random$i",
          yXSTADEST: "Random$i",
          yXSUBLOT: "Random$i");
      listToReturn.add(stock);
    }
    return listToReturn;
  }

  Future<Map<String, dynamic>> createStockTransaction(
      StockTransacionRequest stockTransacionRequest) async {
    return await _repo.createStockTransaction(stockTransacionRequest);
  }
}
