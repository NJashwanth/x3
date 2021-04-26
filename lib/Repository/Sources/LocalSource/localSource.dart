import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:x3/ConfigurationScreen/model/configurationSettingsModel.dart';

class LocalSource {
  static LocalSource instance;

  static getInstance() {
    if (instance == null) instance = LocalSource._newInstance();
    return instance;
  }

  LocalSource._newInstance() {
    openBoxes();
  }

  Future openBoxes() async {
    print("Open boxes called");

    final appDocumentDirectory =
        await pathProvider.getApplicationDocumentsDirectory();

    Hive.init(appDocumentDirectory.path);

    await Hive.openBox("configuration");
    String languageSelected = Hive.box("configuration").get("language");
    if (languageSelected == null)
      Hive.box("configuration").put("language", "ENG");
  }

  Future<void> saveConfiguration(
      ConfigurationSettings configurationSettings) async {
    if (!Hive.isBoxOpen("configuration")) await openBoxes();
    Hive.box("configuration").put("isConfigured", true);
    Hive.box("configuration").put("server", configurationSettings.server);
    Hive.box("configuration").put("port", configurationSettings.port);
    Hive.box("configuration").put("userName", configurationSettings.userName);
    Hive.box("configuration").put("password", configurationSettings.password);
    Hive.box("configuration").put("folder", configurationSettings.folder);
    Hive.box("configuration").put("language", configurationSettings.language);
    Hive.box("configuration").put("urlType", configurationSettings.urlType);
    Hive.box("configuration").put("url", configurationSettings.url);
  }

  Future<Stream<String>> getLanguage() async {
    await Hive.openBox("configuration");
    return Hive.box("configuration").watch(key: "language").map((event) {
      return event.value.toString();
    });
  }

  Future<ConfigurationSettings> getConfiguration() async {
    if (!Hive.isBoxOpen("configuration")) await openBoxes();
    ConfigurationSettings savedSettings = new ConfigurationSettings();
    savedSettings.language = Hive.box("configuration").get("language");
    savedSettings.folder = Hive.box("configuration").get("folder");
    savedSettings.password = Hive.box("configuration").get("password");
    savedSettings.userName = Hive.box("configuration").get("userName");
    savedSettings.port = Hive.box("configuration").get("port");
    savedSettings.server = Hive.box("configuration").get("server");
    return savedSettings;
  }
}
