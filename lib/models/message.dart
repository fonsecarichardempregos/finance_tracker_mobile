import 'package:finance_tracker_app/models/user_model.dart';

class MessageModel {
  MessageModel();

  String? message;


  MessageModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];

  }

  @override
  String toString() {
    return 'MessageModel{message: $message}';
  }
}
