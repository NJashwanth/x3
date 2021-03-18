import 'package:x3/Login/model/userModel.dart';

class LoginBloc {
  static LoginBloc _instance;

  static LoginBloc getInstance() {
    return _instance ?? new LoginBloc();
  }

  void login(UserModel userModel) {}
}
