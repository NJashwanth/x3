class XMLUtils {
  static Uri constructURL(String server, String port) {
    return Uri.parse(
        '$server:$port/soap-generic/syracuse/collaboration/syracuse/CAdxWebServiceXmlCC');
  }
}
