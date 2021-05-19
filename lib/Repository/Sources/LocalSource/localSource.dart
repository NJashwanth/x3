import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:rxdart/rxdart.dart';
import 'package:x3/ConfigurationScreen/model/configurationSettingsModel.dart';

class LocalSource {
  static LocalSource instance;
  String languageSelected;
  int incrementer;

  // ignore: close_sinks
  BehaviorSubject<String> languageBehaviorSubject = new BehaviorSubject();

  BehaviorSubject<TextConfiguration> _textConfigurationBehaviorSubject =
      new BehaviorSubject();

  Stream<TextConfiguration> get textConfigurationStream =>
      _textConfigurationBehaviorSubject.stream;

  Stream<String> get languageStream => languageBehaviorSubject.stream;

  static getInstance() {
    if (instance == null) instance = LocalSource._newInstance();
    return instance;
  }

  LocalSource._newInstance() {
    openBoxes();
  }

  void setLanguage(String language) {
    Hive.box("configuration").put("language", language);
  }

  void setIncrementer(int incrementer) {
    Hive.box("configuration").put("incrementer", incrementer);
  }

  String getLanguage() {
    return Hive.box("configuration").get("language");
  }

  int getIncrementer() {
    return Hive.box("configuration").get("incrementer");
  }

  Future openBoxes() async {
    print("Open boxes called");

    final appDocumentDirectory =
        await pathProvider.getApplicationDocumentsDirectory();

    Hive.init(appDocumentDirectory.path);

    await Hive.openBox("configuration");

    languageSelected = Hive.box("configuration").get("language");
    incrementer = Hive.box("configuration").get("incrementer");

    languageSelected = languageSelected == null ? "ENG" : languageSelected;
    incrementer = incrementer == null ? 0 : incrementer;

    Hive.box("configuration").put("language", languageSelected);
    Hive.box("configuration").put("incrementer", incrementer);
    _textConfigurationBehaviorSubject
        .add(new TextConfiguration(languageSelected, incrementer));
    Hive.box("configuration").watch(key: 'language').listen((event) {
      languageSelected = event.value.toString();
      updateTextConfigurationStream();
    });
    Hive.box("configuration").watch(key: 'incrementer').listen((event) {
      incrementer = int.parse(event.value.toString());
      updateTextConfigurationStream();
    });
  }

  void updateTextConfigurationStream() {
    _textConfigurationBehaviorSubject
        .add(new TextConfiguration(languageSelected, incrementer));
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
    Hive.box("configuration").put("path", configurationSettings.path);
  }

  Stream<TextConfiguration> getTextConfiguration() {
    return textConfigurationStream;
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
    savedSettings.path = Hive.box("configuration").get("path");
    savedSettings.urlType = Hive.box("configuration").get("urlType");

    return savedSettings;
  }

  Future<String> getStockExchangeDocumentId() async {
    String documentId;
    if (!Hive.isBoxOpen("configuration")) await openBoxes();
    documentId =
        Hive.box("configuration").get("documentId", defaultValue: null);
    return documentId;
  }
}

class TextConfiguration {
  String language;
  int incrementer;

  TextConfiguration(this.language, this.incrementer);
}
