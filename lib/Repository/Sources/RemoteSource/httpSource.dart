import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:x3/ConfigurationScreen/model/configurationSettingsModel.dart';
import 'package:x3/HomeScreen/model/UserTaskModel.dart';
import 'package:x3/Login/model/LoginResponse.dart';
import 'package:x3/Login/model/userModel.dart';
import 'package:x3/utils/XMLUtils.dart';
import 'package:xml2json/xml2json.dart';

class HttpSource {
  static HttpSource _instance;
  Dio client = Dio();

  static HttpSource getInstance() {
    if (_instance == null) _instance = new HttpSource();
    return _instance;
  }

  Map<String, String> headers(String userName, String password) {
    Map<String, String> mapToReturn = new Map();
    print("Basic ${base64Encode(utf8.encode('$userName:$password'))}");
    mapToReturn["soapaction"] = "*";
    mapToReturn["Authorization"] =
        'Basic ${base64Encode(utf8.encode('$userName:$password'))}';
    mapToReturn["Content-Type"] = "application/xml";

    return mapToReturn;
  }

  String getAuthorization(String name, String password) {
    return 'Basic ${base64Encode(utf8.encode('$name:$password'))}';
  }

  Future<void> method() async {}

  String parseResponse(String responseStream) {
    print("Response start = ");

    print(responseStream);

    print("Response ends = ");
    final myTransformer = Xml2Json();
    myTransformer.parse(responseStream);
    Map<dynamic, dynamic> json = jsonDecode(myTransformer.toGData());

    //(version, encoding, soapenv$Envelope)
    json = json["soapenv\$Envelope"];
    // (xmlns, xmlns$soapenv, xmlns$xsd, xmlns$xsi, ..., xmlns$wss, soapenv$Body)
    json = json["soapenv\$Body"];

    //wss$runResponse
    json = json["wss\$runResponse"];

    // (soapenv:encodingStyle, runReturn)
    json = json["runReturn"];

    print("xml = " + json.keys.toString());
    print("xml = " + json["messages"].toString());

    // (xsi:type, messages, resultXml, status, technicalInfos)
    json = json["resultXml"];
    print("after result xml =$json");

    String s = json["__cdata"];
    print("c data = $s");
    try {
      s = s.replaceAll("\\n", "");
      s = s.replaceAll("\\t", "");
    } catch (e) {}
    return s;
  }

  Future<LoginResponse> loginNew(
      UserModel userModel, ConfigurationSettings configurationSettings) async {
    var headers = {
      'soapaction': '*',
      'Authorization': 'Basic YWRtaW46YWRtaW4=',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            '${configurationSettings.server}:${configurationSettings.port}/soap-generic/syracuse/collaboration/syracuse/CAdxWebServiceXmlCC'));
    request.body =
        '''<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wss="http://www.adonix.com/WSS">\r\n<soapenv:Header/>\r\n<soapenv:Body>\r\n<wss:run soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">\r\n<callContext xsi:type="wss:CAdxCallContext">\r\n<codeLang xsi:type="xsd:string">ENG</codeLang>\r\n<poolAlias xsi:type="xsd:string">GITDEV</poolAlias>\r\n<poolId xsi:type="xsd:string"></poolId>\r\n<requestConfig xsi:type="xsd:string">adxwss.optreturn=JSON&adxwss.beautify=true</requestConfig>\r\n</callContext>\r\n<publicName xsi:type="xsd:string">YXUSERTASK</publicName>\r\n<inputXml xsi:type="xsd:string">\r\n{\r\n    "GRP1": {\r\n        "YXUSR": "${userModel.userName}",\r\n        "YXPASSWORD": "${userModel.password}"\r\n    }\r\n}\r\n</inputXml>\r\n</wss:run>\r\n</soapenv:Body>\r\n</soapenv:Envelope>\r\n''';
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseStream = await response.stream.bytesToString();
        String s = parseResponse(responseStream);
        print("S = " + s);
        Map<dynamic, dynamic> map = jsonDecode(s);

        List<UserTaskModel> mapToReturn = new List();
        List listFromResponse = map["GRP2"];
        listFromResponse.forEach((element) {
          mapToReturn.add(UserTaskModel.fromJson(element));
        });
        print("Users Task Length is " + mapToReturn.length.toString());
        return new LoginResponse(true, mapToReturn);
      } else {
        return new LoginResponse(false, null);
      }
    } catch (e) {
      print("Exception " + e.toString());
      return new LoginResponse(false, null);
    }
  }

  Future<String> testConnectionNew(
      ConfigurationSettings configurationSettings) async {
    try {
      var request = http.Request(
          'POST',
          XMLUtils.constructURL(
              configurationSettings.server, configurationSettings.port));
      request.body =
          '''<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wss="http://www.adonix.com/WSS">\r\n<soapenv:Header/>\r\n<soapenv:Body>\r\n<wss:run soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">\r\n<callContext xsi:type="wss:CAdxCallContext">\r\n<codeLang xsi:type="xsd:string">ENG</codeLang>\r\n<poolAlias xsi:type="xsd:string">GITDEV</poolAlias>\r\n<poolId xsi:type="xsd:string"></poolId>\r\n<requestConfig xsi:type="xsd:string">adxwss.optreturn=JSON&adxwss.beautify=true</requestConfig>\r\n</callContext>\r\n<publicName xsi:type="xsd:string">YXVERIFYCN</publicName>\r\n<inputXml xsi:type="xsd:string">\r\n{\r\n\r\n}\r\n</inputXml>\r\n</wss:run>\r\n</soapenv:Body>\r\n</soapenv:Envelope>\r\n''';
      request.headers.addAll(headers(
          configurationSettings.userName, configurationSettings.password));

      http.StreamedResponse response =
          await request.send().timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        String responseStream = await response.stream.bytesToString();
        String s = parseResponse(responseStream);
        Map<dynamic, dynamic> json = jsonDecode(s);
        return json["GRP1"]["YXSTATUS"];
      } else {
        print("Error " + response.reasonPhrase);
        return response.reasonPhrase;
      }
    } catch (e) {
      print("Exception " + e.toString());
      return "Internal Error";
    }
  }
}
