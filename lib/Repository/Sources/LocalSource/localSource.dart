class LocalSource {
  static LocalSource instance;

  static getInstance() {
    if (instance == null) instance = new LocalSource();
    return instance;
  }
}
