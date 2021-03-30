class ConfigurationSettings {
  String server;
  String port;
  String userName;
  String password;
  String folder;
  String language;

  ConfigurationSettings(
      {this.server,
      this.port,
      this.userName,
      this.password,
      this.folder,
      this.language});

  ConfigurationSettings.fromJson(Map<String, dynamic> json) {
    server = json['server'];
    port = json['port'];
    userName = json['userName'];
    password = json['password'];
    folder = json['folder'];
    language = json['language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['server'] = this.server;
    data['port'] = this.port;
    data['userName'] = this.userName;
    data['password'] = this.password;
    data['folder'] = this.folder;
    data['language'] = this.language;
    return data;
  }
}
