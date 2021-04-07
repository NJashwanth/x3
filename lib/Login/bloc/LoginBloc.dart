import 'package:rxdart/rxdart.dart';
import 'package:x3/Login/model/LoginResponse.dart';
import 'package:x3/Login/model/userModel.dart';
import 'package:x3/Repository/repo.dart';

class LoginBloc {
  static LoginBloc _instance;
  Repo _repo = Repo.getInstance();

  BehaviorSubject<bool> _loadingController = new BehaviorSubject();

  Stream<bool> get loadingStream => _loadingController.stream;

  static LoginBloc getInstance() {
    if (_instance == null) _instance = new LoginBloc();
    return _instance;
  }

  void changeLoadingState(bool value) {
    _loadingController.add(value);
  }

  Future<LoginResponse> login(UserModel userModel) async {
    return await _repo.login(userModel);
  }
}
