class XMLUtils {
  static Uri constructURL(String server, String port, String path) {
    print("Constructiong url with " +
        Uri.parse('$server:$port/$path').toString());
    return Uri.parse('$server:$port/$path');
  }
}
