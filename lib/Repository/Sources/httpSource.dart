import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:x3/ConfigurationScreen/model/configurationSettingsModel.dart';
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

  Future<String> testConnection(
      ConfigurationSettings configurationSettings) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${configurationSettings.server}:${configurationSettings.port}/soap-generic/syracuse/collaboration/syracuse/CAdxWebServiceXmlCC'));
    request.body =
        '''<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wss="http://www.adonix.com/WSS">\r\n<soapenv:Header/>\r\n<soapenv:Body>\r\n<wss:run soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">\r\n<callContext xsi:type="wss:CAdxCallContext">\r\n<codeLang xsi:type="xsd:string">SPA</codeLang>\r\n<poolAlias xsi:type="xsd:string">GITAPP</poolAlias>\r\n<poolId xsi:type="xsd:string"></poolId>\r\n<requestConfig xsi:type="xsd:string">adxwss.beautify=true</requestConfig>\r\n</callContext>\r\n<publicName xsi:type="xsd:string">ZBASEURL</publicName>\r\n<inputXml xsi:type="xsd:string">\r\n{\r\n\r\n}\r\n</inputXml>\r\n</wss:run>\r\n</soapenv:Body>\r\n</soapenv:Envelope>''';
    request.headers.addAll(headers(
        configurationSettings.userName, configurationSettings.password));

    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseStream = await response.stream.bytesToString();
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
        // (xsi:type, messages, resultXml, status, technicalInfos)
        json = json["resultXml"];
        //(xsi:type, __cdata)
        String s = json["__cdata"];
        myTransformer.parse(s);
        json = jsonDecode(myTransformer.toGData());
        json = json["RESULT"];
        List results = json["GRP"]["FLD"];
        String status = "";
        results.forEach((element) {
          if (element["NAME"] == "ZSTATUS") status = element["\$t"];
        });
        return status;
      } else {
        print("Error " + response.reasonPhrase);
      }
    } catch (e) {
      print("Exception " + e.toString());
      return "Failure";
    }
  }

  Future<void> method() async {}
}
