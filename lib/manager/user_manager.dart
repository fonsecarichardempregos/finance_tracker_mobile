import 'package:finance_tracker_app/models/create_user_model.dart';
import 'package:finance_tracker_app/models/login_model.dart';
import 'package:finance_tracker_app/models/user_model.dart';
import 'package:finance_tracker_app/service/user_service.dart';
import 'package:flutter/material.dart';

class UserManager extends ChangeNotifier {
  final UserService _userService = UserService();

  User? user = User();
  LoginModel? loginModel = LoginModel();
  CreateUserModel? createUserModel = CreateUserModel();
  List<User> users = [];

  // ── Login ────────────────────────────────────
  Future<void> login({String? email, String? password}) async {
    final response = await _userService.login(
      email: email,
      password: password,
    );
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

  // ── Logout ────────────────────────────────────
  void logout() {
    user = User();
    createUserModel = CreateUserModel();
    loginModel = LoginModel();
    notifyListeners();
  }
}
