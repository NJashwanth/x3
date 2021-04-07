import 'package:x3/Login/model/LoginResponse.dart';
import 'package:x3/Login/model/userModel.dart';
import 'package:x3/Repository/repo.dart';

class LoginBloc {
  static LoginBloc _instance;
  Repo _repo = Repo.getInstance();

  static LoginBloc getInstance() {
    return _instance ?? new LoginBloc();
  }

  Future<LoginResponse> login(UserModel userModel) async {
    return await _repo.login(
      userModel,
    );
  }
}
