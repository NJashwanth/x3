class XMLUtils {
  static Uri constructURL(String server, String port, String url) {
    return Uri.parse('$server:$port/$url');
  }
}
