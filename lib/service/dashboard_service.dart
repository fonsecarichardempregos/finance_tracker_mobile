import 'package:dio/dio.dart';
import 'package:finance_tracker_app/models/create_user_model.dart';
import 'package:finance_tracker_app/models/dashboard/dashboard_model.dart';
import 'package:finance_tracker_app/models/login_model.dart';
import 'package:finance_tracker_app/models/verify_token_model.dart';
import 'package:finance_tracker_app/service/api/api_service.dart';

import '../models/message.dart';

class DashboardService {
  static final DashboardService _instance = DashboardService.internal();

  factory DashboardService() => _instance;

  DashboardService.internal();

  final ApiService _apiService = ApiService();

  Future<DashboardModel> getDashboard({String? month, String? year,String? token}) async {
    final response = await _apiService.get(
      query: '/api/dashboard',
      customHeader: {
        'Authorization':
            'Bearer $token',
      },
    );
    print('19831092381092 $response');

    return DashboardModel.fromJson(response);
  }
}
