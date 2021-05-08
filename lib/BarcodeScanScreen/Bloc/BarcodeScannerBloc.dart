import 'package:rxdart/rxdart.dart';
import 'package:x3/BarcodeScanScreen/Model/BarcodeScannerGridModel.dart';

class BarCodeScannerBloc {
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

  void addItemToListStream(
      BarCodeGridModel barCodeGridModel, List<BarCodeGridModel> list) {
    list.add(barCodeGridModel);
    _listOfGridController.add(list);
  }

  void updateStreamList(List<BarCodeGridModel> list) {
    _listOfGridController.add(list);
  }

  void addDataToServer(List<BarCodeGridModel> barCodeModelList) {
    print(barCodeModelList.toString());
  }
}
