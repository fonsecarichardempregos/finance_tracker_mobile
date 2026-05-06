import 'package:finance_tracker_app/models/user_model.dart';

class LoginModel {
  LoginModel();

  String? accessToken;
  String? tokenType;
  num? expiresIn;
  User? user;

  LoginModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    tokenType = json['tokenType'];
    expiresIn = json['expiresIn'];
    if(json['user'] != null){
      user = User.fromJson(json['user']);

    }
  }

  @override
  String toString() {
    return 'LoginModel{accessToken: $accessToken, tokenType: $tokenType, expiresIn: $expiresIn, user: $user}';
  }
}
