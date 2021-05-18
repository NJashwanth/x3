class ConfigurationSettings {
  String server;
  String port;
  String userName;
  String password;
  String folder;
  String language;
  String urlType;
  String path;

  ConfigurationSettings(
      {this.server,
      this.port,
      this.userName,
      this.password,
      this.folder,
      this.language,
      this.urlType,
      this.path});

  ConfigurationSettings.fromJson(Map<String, dynamic> json) {
    server = json['server'];
    port = json['port'];
    userName = json['userName'];
    password = json['password'];
    folder = json['folder'];
    language = json['language'];
    path = json['path'];
  }

  @override
  String toString() {
    return 'ConfigurationSettings{server: $server, port: $port, userName: $userName, password: $password, folder: $folder, language: $language, urlType: $urlType, path: $path}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['server'] = this.server;
    data['port'] = this.port;
    data['userName'] = this.userName;
    data['password'] = this.password;
    data['folder'] = this.folder;
    data['language'] = this.language;
    data['path'] = this.path;
    return data;
  }
}
