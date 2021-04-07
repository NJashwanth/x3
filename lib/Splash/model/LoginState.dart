class LoginState {
  LState lState;
  List<String> homeScreenData;

  LoginState.newState() {
    homeScreenData = null;
    lState = LState.NEW;
  }

  LoginState.savedSettings() {
    this.lState = LState.SETTINGS_CONFIGURED;
    this.homeScreenData = null;
  }
}

enum LState { NEW, SETTINGS_CONFIGURED, LOGGED_IN }
