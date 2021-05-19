import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:x3/BarcodeScanScreen/Model/BarcodeScannerGridModel.dart';
import 'package:x3/ConfigurationScreen/model/configurationSettingsModel.dart';
import 'package:x3/HomeScreen/model/UserTaskModel.dart';
import 'package:x3/Login/model/LoginResponse.dart';
import 'package:x3/Login/model/userModel.dart';
import 'package:x3/utils/HTTPUtils.dart';
import 'package:xml2json/xml2json.dart';

class HttpSource {
  static HttpSource _instance;
  Dio client = Dio();

  static HttpSource getInstance() {
    if (_instance == null) _instance = new HttpSource();
    return _instance;
  }

  Map<String, dynamic> parseResponse(String responseStream) {
    Map<String, dynamic> maptoReturn = new Map();
    final myTransformer = Xml2Json();
    myTransformer.parse(responseStream);
    Map<dynamic, dynamic> json = jsonDecode(myTransformer.toGData());
    json = json["soapenv\$Envelope"];
    json = json["soapenv\$Body"];
    json = json["wss\$runResponse"];
    json = json["runReturn"];
    json = json["resultXml"];
    String s = json["__cdata"];
    if (s == null) {
      Map<dynamic, dynamic> errorJson = jsonDecode(myTransformer.toGData());
      errorJson = errorJson["soapenv\$Envelope"];
      errorJson = errorJson["soapenv\$Body"];
      errorJson = errorJson['multiRef'];
      errorJson = errorJson['message'];
      String s1 = errorJson["\$t"];
      s1 = s1.replaceAll("\'", "");
      s1 = s1.replaceAll("\\", "");
      maptoReturn = {"isSuccess": false, "message": s1};
    } else {
      try {
        s = s.replaceAll("\\n", "");
        s = s.replaceAll("\\t", "");
      } catch (e) {}
      maptoReturn = {"isSuccess": true, "message": s};
    }
    return maptoReturn;
  }

  Future<LoginResponse> login(
      UserModel userModel, ConfigurationSettings configurationSettings) async {
    String api = "YXUSERTASK";
    String requestBody =
        "{\"GRP1\": { \"YXUSR\": \"${userModel.userName}\", \"YXPASSWORD\": \"${userModel.password}\"}}";
    var request =
        HttpUtils.createRequest(configurationSettings, api, requestBody);
    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseStream = await response.stream.bytesToString();
        Map<String, dynamic> dataAfterParsing = parseResponse(responseStream);
        String s = dataAfterParsing['message'];
        if (dataAfterParsing['isSuccess']) {
          Map<dynamic, dynamic> map = jsonDecode(s);
          List<UserTaskModel> mapToReturn = new List();
          List listFromResponse = map["GRP2"];
          listFromResponse.forEach((element) {
            mapToReturn.add(UserTaskModel.fromJson(element));
          });
          List<UserTaskModel> reducedList = new List();
          mapToReturn.reduce((value, element) {
            if (value.yXGUITY != element.yXGUITY ||
                value.yXTASKORD != element.yXTASKORD ||
                value.yXAPP != element.yXAPP ||
                value.yXTASKDESC != element.yXTASKDESC ||
                value.yXTASKNAM != element.yXTASKNAM ||
                value.yXTASKNUM0 != element.yXTASKNUM0) reducedList.add(value);
            return element;
          });
          reducedList.add(mapToReturn.last);
          print(reducedList.toString());
          return new LoginResponse(true, reducedList);
        } else {
          return new LoginResponse(false, null, failureReason: s);
        }
      } else {
        return new LoginResponse(false, null,
            failureReason: response.reasonPhrase);
      }
    } catch (e) {
      print("Exception " + e.toString());
      return new LoginResponse(false, null, failureReason: e.toString());
    }
  }

  Future<String> testConnection(
      ConfigurationSettings configurationSettings) async {
    try {
      var request =
          HttpUtils.createRequest(configurationSettings, "YXVERIFYCN", "{}");
      http.StreamedResponse response =
          await request.send().timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        String responseStream = await response.stream.bytesToString();
        Map<String, dynamic> dataAfterParsing = parseResponse(responseStream);
        String s = dataAfterParsing['message'];
        if (dataAfterParsing['isSuccess']) {
          Map<dynamic, dynamic> json = jsonDecode(s);
          return json["GRP1"]["YXSTATUS"];
        } else
          return "Failure";
      } else {
        print("Error " + response.reasonPhrase);
        return "Failure";
      }
    } catch (e) {
      return "Failure";
    }
  }

  Future<int> createUB(List<UBEntriesGridModel> ubEntries,
      ConfigurationSettings configurationSettings) async {
    UBRequestBody requestBody = new UBRequestBody(ubEntries);
    var request = HttpUtils.createRequest(configurationSettings, "YXCREATEUB",
        "${requestBody.toJson().toString()}");
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseStream = await response.stream.bytesToString();
      print("responseStream " + responseStream);
      final myTransformer = Xml2Json();
      myTransformer.parse(responseStream);
      Map<dynamic, dynamic> json = jsonDecode(myTransformer.toGData());

      json = json["soapenv\$Envelope"];
      json = json["soapenv\$Body"];

      json = json["wss\$runResponse"];
      json = json["runReturn"];
      json = json["resultXml"];

      print(json["__cdata"].toString());
      if (json["__cdata"] != null) {
        myTransformer.parse(json["__cdata"].toString());
        json = jsonDecode(myTransformer.toGData());
        print("Cdata = " + json["RESULT"].toString());
        print("Cdata = " + json["RESULT"]["TAB"]["SIZE"].toString());
        return int.parse(json["RESULT"]["TAB"]["SIZE"]);
      } else {
        print("c data is null");

        return -1;
      }
    } else {
      print("Reason phrase " + request.toString());
      return -1;
    }
  }

  getStockDetails(ConfigurationSettings configurationSettings) async {
    var headers = {
      'soapaction': '*',
      'Authorization': 'Basic YWRtaW46YWRtaW4=',
      'Content-Type': 'application/xml'
    };

    var request = http.Request(
        'POST',
        Uri.parse(
            'http://sagex3v12.germinit.com:8124/soap-generic/syracuse/collaboration/syracuse/CAdxWebServiceXmlCC'));
    String api = "YXSTKCHGPL";
    String inputXml =
        "{\"GRP1\":{\"YXSRCTYP\":\"19\",\"YXSTOFCY\":\"AU012\",\"YXDOCNUM\":\"MRCAU0120011\",\"YXSLO\":\"STO1201\",\"YXSRCLOC\":\"QUA01\",\"YXDSTLOC\":\"QUA02\"}}";

    request.body =
        '''<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wss="http://www.adonix.com/WSS"><soapenv:Header/><soapenv:Body><wss:run soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><callContext xsi:type="wss:CAdxCallContext"><codeLang xsi:type="xsd:string">ENG</codeLang><poolAlias xsi:type="xsd:string">GITDEV</poolAlias><poolId xsi:type="xsd:string"></poolId><requestConfig xsi:type="xsd:string">adxwss.beautify=true</requestConfig></callContext><publicName xsi:type="xsd:string">$api</publicName><inputXml xsi:type="xsd:string">$inputXml</inputXml></wss:run></soapenv:Body></soapenv:Envelope>''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseStream = await response.stream.bytesToString();
      Map<String, dynamic> dataAfterParsing = parseResponse(responseStream);
      String s = dataAfterParsing['message'];
      // print("response = " + s);
      if (dataAfterParsing['isSuccess']) {
        final myTransformer = Xml2Json();
        myTransformer.parse(s);
        Map<dynamic, dynamic> json = jsonDecode(myTransformer.toGData());
        print(json["RESULT"].toString());
        return json;
      } else
        return "Failure2";
    } else {
      print("Error " + response.reasonPhrase);
      return "Failure1";
    }
  }
}

class UBRequestBody {
  List<UBEntriesGridModel> entries = [];

  UBRequestBody(this.entries);

  String toJson() {
    String mapToReturn = "\"GRP1\":[";
    int totalEntries = 0;
    entries.forEach((element) {
      if (totalEntries > 0) mapToReturn += ",";
      mapToReturn +=
          "{\"YXSLO\":\"${element.document}\",\"YXLOC\":\"${element.location}\",\"YXLOT\":\"${element.barcode}\",\"YXINTEGRATED\":1}";
    });
    mapToReturn += "]";
    print("mapToReturn " + mapToReturn);
    return mapToReturn;
  }
}
