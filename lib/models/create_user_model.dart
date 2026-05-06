import 'package:finance_tracker_app/models/user_model.dart';

class CreateUserModel {
  CreateUserModel();

  String? message;
  User? user;

  CreateUserModel.fromJson(Map<String, dynamic> json) {
    message = json['accessToken'];

    if(json['user'] != null){
      user = User.fromJson(json['user']);

    }
  }

  @override
  String toString() {
    return 'LoginModel{message: $message, user: $user}';
  }
}
