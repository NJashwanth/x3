class StockExchangeGridModel {
  GRP gRP;
  TAB tAB;

  StockExchangeGridModel({this.gRP, this.tAB});

  StockExchangeGridModel.fromJson(Map<String, dynamic> json) {
    gRP = json['GRP'] != null ? new GRP.fromJson(json['GRP']) : null;
    tAB = json['TAB'] != null ? new TAB.fromJson(json['TAB']) : null;
  }

  @override
  String toString() {
    return 'StockExchangeGridModel{gRP: $gRP, tAB: $tAB}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.gRP != null) {
      data['GRP'] = this.gRP.toJson();
    }
    if (this.tAB != null) {
      data['TAB'] = this.tAB.toJson();
    }
    return data;
  }
}

class GRP {
  String iD;
  List<FLD> fLD;

  @override
  String toString() {
    return 'GRP{iD: $iD, fLD: $fLD}';
  }

  GRP({this.iD, this.fLD});

  GRP.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    if (json['FLD'] != null) {
      fLD = new List<FLD>();
      json['FLD'].forEach((v) {
        fLD.add(new FLD.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    if (this.fLD != null) {
      data['FLD'] = this.fLD.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FLD {
  String nAME;
  String tYPE;
  String t;
  bool isChecked;

  @override
  String toString() {
    return 'FLD{nAME: $nAME, tYPE: $tYPE, t: $t, isChecked: $isChecked}';
  }

  FLD({this.nAME, this.tYPE, this.t, this.isChecked});

  FLD.fromJson(Map<String, dynamic> json) {
    nAME = json['NAME'];
    tYPE = json['TYPE'];
    t = json['$t'];
    isChecked = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NAME'] = this.nAME;
    data['TYPE'] = this.tYPE;
    data['$t'] = this.t;
    return data;
  }
}

class TAB {
  String dIM;
  String iD;
  String sIZE;
  LIN lIN;

  TAB({this.dIM, this.iD, this.sIZE, this.lIN});

  @override
  String toString() {
    return 'TAB{dIM: $dIM, iD: $iD, sIZE: $sIZE, lIN: $lIN}';
  }

  TAB.fromJson(Map<String, dynamic> json) {
    dIM = json['DIM'];
    iD = json['ID'];
    sIZE = json['SIZE'];
    lIN = json['LIN'] != null ? new LIN.fromJson(json['LIN']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DIM'] = this.dIM;
    data['ID'] = this.iD;
    data['SIZE'] = this.sIZE;
    if (this.lIN != null) {
      data['LIN'] = this.lIN.toJson();
    }
    return data;
  }
}

class LIN {
  String nUM;
  List<FLD> fLD;

  LIN({this.nUM, this.fLD});

  LIN.fromJson(Map<String, dynamic> json) {
    nUM = json['NUM'] as String;
    if (json['FLD'] != null) {
      fLD = new List<FLD>();
      json['FLD'].forEach((v) {
        fLD.add(new FLD.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NUM'] = this.nUM;
    if (this.fLD != null) {
      data['FLD'] = this.fLD.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
