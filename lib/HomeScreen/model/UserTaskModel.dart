class UserTaskModel {
  String yXTASKNUM0;
  String yXTASKNAM;
  String yXTASKDESC;
  String yXAPP;
  String yXGUITY;
  int yXTASKORD;
  int yXSOURCEDOC;
  int yXSOURCETYP;
  String yXSOURCEPRG;
  String yXSOURCESUBP;
  String yXSCANFIELD;
  String yXSOUSTOFCY;
  String yXSOULOC;
  String yXDESTPRG;
  String yXDESTSUBP;
  String yXDESTSTOFCY;
  String yXDESTLOC;
  int yXTASKLIN;
  String yXTASKNUM;
  String yXPARAM;
  String yXPARAMTEXT;
  String yXDISPLAY;
  int yXCOLUMNORD;
  int yXSORTORD;
  int yXSTOFCYLEN;
  int yXDOCNUMLEN;
  int yXSLOLEN;
  int yXSRCLOCLEN;
  int yXDSTLOCLEN;

  UserTaskModel(
      {this.yXTASKNUM0,
      this.yXTASKNAM,
      this.yXTASKDESC,
      this.yXAPP,
      this.yXGUITY,
      this.yXTASKORD,
      this.yXSOURCEDOC,
      this.yXSOURCETYP,
      this.yXSOURCEPRG,
      this.yXSOURCESUBP,
      this.yXSCANFIELD,
      this.yXSOUSTOFCY,
      this.yXSOULOC,
      this.yXDESTPRG,
      this.yXDESTSUBP,
      this.yXDESTSTOFCY,
      this.yXDESTLOC,
      this.yXTASKLIN,
      this.yXTASKNUM,
      this.yXPARAM,
      this.yXPARAMTEXT,
      this.yXDISPLAY,
      this.yXCOLUMNORD,
      this.yXSORTORD,
      this.yXSTOFCYLEN,
      this.yXDOCNUMLEN,
      this.yXSLOLEN,
      this.yXSRCLOCLEN,
      this.yXDSTLOCLEN});

  UserTaskModel.fromJson(Map<String, dynamic> json) {
    yXTASKNUM0 = json['YXTASKNUM0'];
    yXTASKNAM = json['YXTASKNAM'];
    yXTASKDESC = json['YXTASKDESC'];
    yXAPP = json['YXAPP'];
    yXGUITY = json['YXGUITY'];
    yXTASKORD = int.parse(json['YXTASKORD'].toString());
    yXSOURCEDOC = int.parse(json['YXSOURCEDOC'].toString());
    yXSOURCETYP = int.parse(json['YXSOURCETYP'].toString());
    yXSOURCEPRG = json['YXSOURCEPRG'];
    yXSOURCESUBP = json['YXSOURCESUBP'];
    yXSCANFIELD = json['YXSCANFIELD'];
    yXSOUSTOFCY = json['YXSOUSTOFCY'];
    yXSOULOC = json['YXSOULOC'];
    yXDESTPRG = json['YXDESTPRG'];
    yXDESTSUBP = json['YXDESTSUBP'];
    yXDESTSTOFCY = json['YXDESTSTOFCY'];
    yXDESTLOC = json['YXDESTLOC'];
    yXTASKLIN = int.parse(json['YXTASKLIN'].toString());
    yXTASKNUM = json['YXTASKNUM'];
    yXPARAM = json['YXPARAM'];
    yXPARAMTEXT = json['YXPARAMTEXT'];
    yXDISPLAY = json['YXDISPLAY'];
    yXCOLUMNORD = int.parse(json['YXCOLUMNORD'].toString());
    yXSORTORD = int.parse(json['YXSORTORD'].toString());
    yXSTOFCYLEN = int.parse(json['YXSTOFCYLEN'].toString());
    yXDOCNUMLEN = int.parse(json['YXDOCNUMLEN'].toString());
    yXSLOLEN = int.parse(json['YXSLOLEN'].toString());
    yXSRCLOCLEN = int.parse(json['YXSRCLOCLEN'].toString());
    yXDSTLOCLEN = int.parse(json['YXDSTLOCLEN'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['YXTASKNUM0'] = this.yXTASKNUM0;
    data['YXTASKNAM'] = this.yXTASKNAM;
    data['YXTASKDESC'] = this.yXTASKDESC;
    data['YXAPP'] = this.yXAPP;
    data['YXGUITY'] = this.yXGUITY;
    data['YXTASKORD'] = this.yXTASKORD;
    data['YXSOURCEDOC'] = this.yXSOURCEDOC;
    data['YXSOURCETYP'] = this.yXSOURCETYP;
    data['YXSOURCEPRG'] = this.yXSOURCEPRG;
    data['YXSOURCESUBP'] = this.yXSOURCESUBP;
    data['YXSCANFIELD'] = this.yXSCANFIELD;
    data['YXSOUSTOFCY'] = this.yXSOUSTOFCY;
    data['YXSOULOC'] = this.yXSOULOC;
    data['YXDESTPRG'] = this.yXDESTPRG;
    data['YXDESTSUBP'] = this.yXDESTSUBP;
    data['YXDESTSTOFCY'] = this.yXDESTSTOFCY;
    data['YXDESTLOC'] = this.yXDESTLOC;
    data['YXTASKLIN'] = this.yXTASKLIN;
    data['YXTASKNUM'] = this.yXTASKNUM;
    data['YXPARAM'] = this.yXPARAM;
    data['YXPARAMTEXT'] = this.yXPARAMTEXT;
    data['YXDISPLAY'] = this.yXDISPLAY;
    data['YXCOLUMNORD'] = this.yXCOLUMNORD;
    data['YXSORTORD'] = this.yXSORTORD;
    data['YXSTOFCYLEN'] = this.yXSTOFCYLEN;
    data['YXDOCNUMLEN'] = this.yXDOCNUMLEN;
    data['YXSLOLEN'] = this.yXSLOLEN;
    data['YXSRCLOCLEN'] = this.yXSRCLOCLEN;
    data['YXDSTLOCLEN'] = this.yXDSTLOCLEN;
    return data;
  }

  @override
  String toString() {
    return 'UserTaskModel{yXTASKNUM0: $yXTASKNUM0, yXTASKNAM: $yXTASKNAM, yXTASKDESC: $yXTASKDESC, yXAPP: $yXAPP, yXGUITY: $yXGUITY, yXTASKORD: $yXTASKORD, yXSOURCEDOC: $yXSOURCEDOC, yXSOURCETYP: $yXSOURCETYP, yXSOURCEPRG: $yXSOURCEPRG, yXSOURCESUBP: $yXSOURCESUBP, yXSCANFIELD: $yXSCANFIELD, yXSOUSTOFCY: $yXSOUSTOFCY, yXSOULOC: $yXSOULOC, yXDESTPRG: $yXDESTPRG, yXDESTSUBP: $yXDESTSUBP, yXDESTSTOFCY: $yXDESTSTOFCY, yXDESTLOC: $yXDESTLOC, yXTASKLIN: $yXTASKLIN, yXTASKNUM: $yXTASKNUM, yXPARAM: $yXPARAM, yXPARAMTEXT: $yXPARAMTEXT, yXDISPLAY: $yXDISPLAY, yXCOLUMNORD: $yXCOLUMNORD, yXSORTORD: $yXSORTORD, yXSTOFCYLEN: $yXSTOFCYLEN, yXDOCNUMLEN: $yXDOCNUMLEN, yXSLOLEN: $yXSLOLEN, yXSRCLOCLEN: $yXSRCLOCLEN, yXDSTLOCLEN: $yXDSTLOCLEN}';
  }
}
