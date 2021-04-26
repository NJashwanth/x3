import 'package:x3/HomeScreen/model/UserTaskModel.dart';

class LoginResponse {
  bool isSuccess;
  List<UserTaskModel> grp2;
  String failureReason;

  LoginResponse(this.isSuccess, this.grp2, {this.failureReason});
}
