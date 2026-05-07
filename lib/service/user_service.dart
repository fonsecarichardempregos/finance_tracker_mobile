import 'package:dio/dio.dart';
import 'package:finance_tracker_app/models/create_user_model.dart';
import 'package:finance_tracker_app/models/login_model.dart';
import 'package:finance_tracker_app/models/verify_token_model.dart';
import 'package:finance_tracker_app/service/api/api_service.dart';

import '../models/message.dart';

class UserService {
  static final UserService _instance = UserService.internal();

  factory UserService() => _instance;

  UserService.internal();

  final ApiService _apiService = ApiService();

  // ── Cadastro ─────────────────────────────────
  Future<CreateUserModel> createUser({
    String? fullName,
    String? email,
    String? password,
    String? phone,
    String? birthDate,
  }) async {
    // DioException é lançada automaticamente em caso de erro HTTP (4xx/5xx)
    // O try-catch fica na tela via UserManager — aqui só executa
    final response = await _apiService.post(
      query: '/api/auth/register',
      customHeader: {},
      body: {
        'fullName': fullName,
        'email': email,
        'password': password,
        'phone': phone,
        'birthDate': birthDate,
      },
    );
    print('19831092381092 $response');

    return CreateUserModel.fromJson(response);
  }

  // ── Login ─────────────────────────────────────
  Future<LoginModel> login({String? email, String? password}) async {
    final response = await _apiService.post(
      query: '/api/auth/login',
      customHeader: {},
      body: {'email': email, 'password': password},
    );

    print('19831092381092 $response');

    return LoginModel.fromJson(response);
  }

  Future<MessageModel> sendCodeResetPassword({String? email}) async {
    final response = await _apiService.post(
      query: '/api/auth/password-reset/request',
      customHeader: {},
      body: {'email': email},
    );

    print('19831092381092 $response');

    return MessageModel.fromJson(response);
  }

  Future<VerifyTokenModel> verifyTokenResetPassword({
    String? email,
    String? code,
  }) async {
    final response = await _apiService.post(
      query: '/api/auth/password-reset/verify',
      customHeader: {},
      body: {'email': email, 'code': code},
    );

    print('19831092381092 $response');

    return VerifyTokenModel.fromJson(response);
  }

  Future<MessageModel> resetPassword({
    String? resetToken,
    String? newPassword,
    String? confirmNewPassword,
  }) async {
    final response = await _apiService.post(
      query: '/api/auth/password-reset/reset',
      customHeader: {},
      body: {
        'resetToken': resetToken,
        'newPassword': newPassword,
        'confirmNewPassword': confirmNewPassword,
      },
    );

    print('19831092381092 $response');

    return MessageModel.fromJson(response);
  }
}
