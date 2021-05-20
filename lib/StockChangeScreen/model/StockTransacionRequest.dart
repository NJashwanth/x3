import 'package:x3/HomeScreen/model/UserTaskModel.dart';

class StockTransacionRequest {
  GRP1 gRP1;
  List<Stock> gRP2;
  String publicName;
  UserTaskModel userTaskModel;

  StockTransacionRequest(
      {this.gRP1, this.gRP2, this.publicName, this.userTaskModel});

  StockTransacionRequest.fromJson(Map<String, dynamic> json) {
    gRP1 = json['GRP1'] != null ? new GRP1.fromJson(json['GRP1']) : null;
    if (json['GRP2'] != null) {
      gRP2 = new List<Stock>();
      json['GRP2'].forEach((v) {
        gRP2.add(new Stock.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.gRP1 != null) {
      data['GRP1'] = this.gRP1.toJson();
    }
    if (this.gRP2 != null) {
      data['GRP2'] = this.gRP2.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GRP1 {
  String yXSTOFCY;
  static final String yXDOCTYP = "CHG";

  String yXDESC;

  GRP1({this.yXSTOFCY, this.yXDESC});

  GRP1.fromJson(Map<String, dynamic> json) {
    yXSTOFCY = json['YXSTOFCY'];
    yXDESC = json['YXDESC'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['YXSTOFCY'] = this.yXSTOFCY;
    data['YXDESC'] = this.yXDESC;
    return data;
  }
}

class Stock {
  String yXITMREF;
  String yXPCU;
  String yXQTY;
  String yXSTA;
  String yXLOCTYP;
  String yXLOC;
  String yXDESTLOC;
  String yXSTADEST;
  String yXLOT;
  String yXSUBLOT;
  bool isChecked;

  Stock({this.yXITMREF,
    this.yXPCU,
    this.yXQTY,
    this.yXSTA,
    this.yXLOCTYP,
    this.yXLOC,
    this.yXDESTLOC,
    this.yXSTADEST,
    this.yXLOT,
    this.yXSUBLOT,
    this.isChecked});

  Stock.fromJson(Map<String, dynamic> json) {
    yXITMREF = json['YXITMREF'];
    yXPCU = json['YXPCU'];
    yXQTY = json['YXQTY'];
    yXSTA = json['YXSTA'];
    yXLOCTYP = json['YXLOCTYP'];
    yXLOC = json['YXLOC'];
    yXDESTLOC = json['YXDESTLOC'];
    yXSTADEST = json['YXSTADEST'];
    yXLOT = json['YXLOT'];
    yXSUBLOT = json['YXSUBLOT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['YXITMREF'] = this.yXITMREF;
    data['YXPCU'] = this.yXPCU;
    data['YXQTY'] = this.yXQTY;
    data['YXSTA'] = this.yXSTA;
    data['YXLOCTYP'] = this.yXLOCTYP;
    data['YXLOC'] = this.yXLOC;
    data['YXDESTLOC'] = this.yXDESTLOC;
    data['YXSTADEST'] = this.yXSTADEST;
    data['YXLOT'] = this.yXLOT;
    data['YXSUBLOT'] = this.yXSUBLOT;
    return data;
  }
}
