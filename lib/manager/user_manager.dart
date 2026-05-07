import 'package:finance_tracker_app/models/create_user_model.dart';
import 'package:finance_tracker_app/models/login_model.dart';
import 'package:finance_tracker_app/models/user_model.dart';
import 'package:finance_tracker_app/models/verify_token_model.dart';
import 'package:finance_tracker_app/service/user_service.dart';
import 'package:flutter/material.dart';

import '../models/message.dart';

class UserManager extends ChangeNotifier {
  final UserService _userService = UserService();

  User? user = User();
  LoginModel? loginModel = LoginModel();
  CreateUserModel? createUserModel = CreateUserModel();
  MessageModel? messageModel = MessageModel();
  VerifyTokenModel? verifyTokenModel = VerifyTokenModel();
  List<User> users = [];

  // ── Login ────────────────────────────────────
  Future<void> login({String? email, String? password}) async {
    final response = await _userService.login(email: email, password: password);
    loginModel = response;
    notifyListeners();
  }

  // ── Cadastro ─────────────────────────────────
  Future<void> createUser({
    String? email,
    String? password,
    String? fullName,
    String? birthDate,
    String? phone,
  }) async {
    final response = await _userService.createUser(
      fullName: fullName,
      birthDate: birthDate,
      phone: phone,
      email: email,
      password: password,
    );
    createUserModel = response;
    notifyListeners();
  }

  Future<void> sendCodeResetPassword({String? email}) async {
    final response = await _userService.sendCodeResetPassword(email: email);
    messageModel = response;
    notifyListeners();
  }

  Future<void> verifyCodeResetPassword({String? email, String? code}) async {
    final response = await _userService.verifyTokenResetPassword(
      email: email,
      code: code,
    );
    verifyTokenModel = response;
    notifyListeners();
  }

  Future<void> resetPassword({
    String? confirmNewPassword,
    String? newPassword,
  }) async {
    final response = await _userService.resetPassword(
      confirmNewPassword: confirmNewPassword,
      newPassword: newPassword,
      resetToken: verifyTokenModel?.resetToken,
    );
    messageModel = response;
    notifyListeners();
  }

  // ── Logout ────────────────────────────────────
  void logout() {
    user = User();
    createUserModel = CreateUserModel();
    loginModel = LoginModel();
    notifyListeners();
  }
}
