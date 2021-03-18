import 'dart:convert';

import 'package:dio/dio.dart';

class HomeBloc {
  static HomeBloc _instance;
  Dio client = Dio();

  static HomeBloc getInstance() {
    if (_instance == null) _instance = new HomeBloc();
    return _instance;
  }

  Future<void> onConfigPressed() async {
    final url =
        'http://sagex3v12.germinit.com:8124/soap-generic/syracuse/collaboration/syracuse/CAdxWebServiceXmlCC';

    final configXml = configBody(folder: "PROD", language: "ENG");
    print("True");
    try {
      final Response response = await client.request(url,
          data: configXml,
          options: Options(method: 'POST', headers: {
            'Content-Type': "ext/xml",
            'SOAPAction': "*",
            'Authorization':
                'Basic ${base64Encode(utf8.encode('ADMIN:admin'))}',
          }));
      print("Response = ${response.data.toString()}");
    } catch (e) {
      print("Server error $e");
    }
  }

  String configBody({String folder, String language}) {
    return '''
  <?xml version="1.0" encoding="UTF-8"?>
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wss="http://www.adonix.com/WSS" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
       <soapenv:Header />
       <soapenv:Body>
          <wss:run soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
             <callContext xsi:type="wss:CAdxCallContext">
                <codeLang xsi:type="xsd:string">$language</codeLang>
                <poolAlias xsi:type="xsd:string">$folder</poolAlias>
                <poolId xsi:type="xsd:string" />
                <requestConfig xsi:type="xsd:string">adxwss.beautify=true</requestConfig>
             </callContext>
             <publicName xsi:type="xsd:string">YXVERIFYCN</publicName>
             <inputXml xsi:type="xsd:string">{}</inputXml>
          </wss:run>
      </soapenv:Body>
    </soapenv:Envelope>''';
  }

  Future<void> onLoginPressed() async {
    print("login server ");
    try {
      final String inputXml = '{"GRP1":{"YXUSR":"ADMIN","YXPASSWORD":"admin"}}';
      const String publicName = 'YXUSERTASK';

      final String url =
          'http://sagex3-1:8124/soap-generic/syracuse/collaboration/syracuse/CAdxWebServiceXmlCC';
      final String xml = _xmlString("ENG", "PROD", inputXml, publicName);
      client.request(url,
          data: xml,
          options: Options(
              method: 'POST',
              sendTimeout: 5000,
              receiveTimeout: 3000,
              headers: {
                'Content-Type': 'text/xml',
                'SOAPAction': '*',
                'Authorization':
                    'Basic ${base64Encode(utf8.encode('ADMIN:admin'))}',
              }));
    } on DioError catch (e) {
      print("dio error");
    } catch (e) {
      print("error is $e");
    }
  }

  String _xmlString(
      String language, String folder, String inputXml, String publicName) {
    return '''
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wss="http://www.adonix.com/WSS" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <soapenv:Header />
      <soapenv:Body>
          <wss:run soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
            <callContext xsi:type="wss:CAdxCallContext">
                <codeLang xsi:type="xsd:string">$language</codeLang>
                <poolAlias xsi:type="xsd:string">$folder</poolAlias>
                <poolId xsi:type="xsd:string" />
                <requestConfig xsi:type="xsd:string">adxwss.beautify=true</requestConfig>
            </callContext>
            <publicName xsi:type="xsd:string">$publicName</publicName>
            <inputXml xsi:type="xsd:string">  $inputXml </inputXml>
          </wss:run>
      </soapenv:Body>
    </soapenv:Envelope>''';
  }
}
