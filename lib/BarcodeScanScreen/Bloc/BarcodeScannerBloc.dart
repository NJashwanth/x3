import 'package:rxdart/rxdart.dart';
import 'package:x3/BarcodeScanScreen/Model/BarcodeScannerGridModel.dart';
import 'package:x3/Repository/repo.dart';

class BarCodeScannerBloc {
  Repo _repo = Repo.getInstance();

  static BarCodeScannerBloc _instance;

  static BarCodeScannerBloc getInstance() {
    if (_instance == null) _instance = new BarCodeScannerBloc();
    return _instance;
  }

  // ignore: close_sinks
  BehaviorSubject<List<BarCodeGridModel>> _listOfGridController =
      new BehaviorSubject();

  Stream<List<BarCodeGridModel>> get listOfGridStream =>
      _listOfGridController.stream;

  // ignore: close_sinks
  BehaviorSubject<int> _noOfItemsController = new BehaviorSubject();

  Stream<int> get numberOfItemsStream => _noOfItemsController.stream;

  void addItemToListStream(
      BarCodeGridModel barCodeGridModel, List<BarCodeGridModel> list) {
    list.add(barCodeGridModel);
    _listOfGridController.add(list);
  }

  void updateStreamList(List<BarCodeGridModel> list) {
    _listOfGridController.add(list);
  }

  Future<int> addDataToServer(List<BarCodeGridModel> barCodeModelList) async {
    print(barCodeModelList.toString());
    print("Items To Be Sent = ${barCodeModelList.length}");
    return await _repo.sendUBEntries(barCodeModelList);
  }

  void addNoOfItemsToStream(int numberOfItems) {
    _noOfItemsController.add(numberOfItems);
  }

  void clearDocumentsCount() {
    _noOfItemsController.add(0);
  }
}
