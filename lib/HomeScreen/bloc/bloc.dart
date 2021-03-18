import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class HomeBloc {
  static HomeBloc _instance;
  Dio client = Dio();

  static HomeBloc getInstance() {
    if (_instance == null) _instance = new HomeBloc();
    return _instance;
  }

  var headers = {
    'soapaction': '*',
    'Authorization': 'Basic YWRtaW46YWRtaW4=',
    'Content-Type': 'application/xml'
  };

  Future<void> onConfigPressed() async {
    final url =
        'http://sagex3v12.germinit.com:8124/soap-generic/syracuse/collaboration/syracuse/CAdxWebServiceXmlCC';

    final configXml = configBody(folder: "PROD", language: "ENG");
    try {
      final Response response = await client.request(url,
          data: configXml, options: Options(method: 'POST', headers: headers));
      print("Response = ${response.data.toString()}");
    } catch (e) {
      print("Server error $e");
    }
  }

  void getSavedConfigurations() {}

  void testSavedConfigurations() {}

  void saveConfigurations() {}

  void login() {}

  void getHomeScreenData() {}

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

  Future<void> method() async {
    var request = http.Request(
        'POST',
        Uri.parse(
            'http://sagex3v12.germinit.com:8124/soap-generic/syracuse/collaboration/syracuse/CAdxWebServiceXmlCC'));
    request.body =
        '''<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wss="http://www.adonix.com/WSS">\r\n<soapenv:Header/>\r\n<soapenv:Body>\r\n<wss:run soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">\r\n<callContext xsi:type="wss:CAdxCallContext">\r\n<codeLang xsi:type="xsd:string">SPA</codeLang>\r\n<poolAlias xsi:type="xsd:string">GITAPP</poolAlias>\r\n<poolId xsi:type="xsd:string"></poolId>\r\n<requestConfig xsi:type="xsd:string">adxwss.beautify=true</requestConfig>\r\n</callContext>\r\n<publicName xsi:type="xsd:string">ZBASEURL</publicName>\r\n<inputXml xsi:type="xsd:string">\r\n{\r\n\r\n}\r\n</inputXml>\r\n</wss:run>\r\n</soapenv:Body>\r\n</soapenv:Envelope>''';
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseStream = await response.stream.bytesToString();
        print(responseStream);
      } else {
        print("Error " + response.reasonPhrase);
      }
    } catch (e) {
      print("Exception " + e.toString());
    }
  }

  void onLoginPressed() {
    method();
  }
}
