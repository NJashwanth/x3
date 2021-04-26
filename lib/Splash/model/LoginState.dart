import 'package:x3/HomeScreen/model/UserTaskModel.dart';

class LoginState {
  LState lState;
  List<UserTaskModel> homeScreenData;

  LoginState.newState() {
    homeScreenData = null;
    lState = LState.NEW;
  }

  LoginState.savedSettings() {
    this.lState = LState.SETTINGS_CONFIGURED;
    this.homeScreenData = null;
  }

  LoginState.splash() {
    this.lState = LState.SPLASH;
    this.homeScreenData = null;
  }
}

enum LState { NEW, SETTINGS_CONFIGURED, LOGGED_IN, SPLASH }
