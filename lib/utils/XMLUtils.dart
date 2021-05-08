class XMLUtils {
  static Uri constructURL(String server, String port, String url) {
    print(
        "Constructiong url with " + Uri.parse('$server:$port/$url').toString());
    return Uri.parse('$server:$port/$url');
  }
}
