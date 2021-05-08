class BarCodeGridModel {
  String document;
  String barcode;
  String location;
  bool isChecked;

  BarCodeGridModel(this.document, this.barcode, this.location, this.isChecked);

  @override
  String toString() {
    return 'BarCodeGridModel{document: $document, barcode: $barcode, location: $location, isChecked: $isChecked}';
  }
}
