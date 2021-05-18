import 'dart:convert';

import 'package:http/http.dart';
import 'package:x3/ConfigurationScreen/model/configurationSettingsModel.dart';
import 'package:x3/utils/XMLUtils.dart';

class HttpUtils {
  static Request createRequest(ConfigurationSettings configurationSettings,
      String api, String inputXML) {
    Request request = Request(
        'POST',
        XMLUtils.constructURL(
          configurationSettings.server,
          configurationSettings.port,
          configurationSettings.path,
        ));
    request.headers.addAll(headers(
        configurationSettings.userName, configurationSettings.password));
    request.body = createBody(configurationSettings, api, inputXML);

    return request;
  }

  static Map<String, String> headers(String name, String password) {
    Map<String, String> mapToReturn = new Map();
    print("Basic ${base64Encode(utf8.encode('$name:$password'))}");
    mapToReturn["soapaction"] = "*";
    mapToReturn["Authorization"] = getAuthorization(name, password);
    mapToReturn["Content-Type"] = "application/xml";

    return mapToReturn;
  }

  static String getAuthorization(String name, String password) {
    return 'Basic ${base64Encode(utf8.encode('$name:$password'))}';
  }

  static String createBody(ConfigurationSettings configurationSettings,
      String api, String inputXML) {
    return '''<soapenv:Envelope
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:wss="http://www.adonix.com/WSS">
	<soapenv:Header/>
	<soapenv:Body>
		<wss:run soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
			<callContext xsi:type="wss:CAdxCallContext">
				<codeLang xsi:type="xsd:string">${configurationSettings.language}</codeLang>
				<poolAlias xsi:type="xsd:string">${configurationSettings.folder.toUpperCase()}</poolAlias>
				<poolId xsi:type="xsd:string"></poolId>
				<requestConfig xsi:type="xsd:string">adxwss.optreturn=JSON&adxwss.beautify=true</requestConfig>
			</callContext>
			<publicName xsi:type="xsd:string">$api</publicName>
			<inputXml xsi:type="xsd:string">
 $inputXML
 </inputXml>
		</wss:run>
	</soapenv:Body>
</soapenv:Envelope>''';
  }
}
