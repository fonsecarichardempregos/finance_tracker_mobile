import 'package:dio/dio.dart';
import 'package:finance_tracker_app/models/dashboard/dashboard_model.dart';
import 'package:finance_tracker_app/service/dashboard_service.dart';
import 'package:flutter/material.dart';

class DashboardManager extends ChangeNotifier {
  final DashboardService _dashboardService = DashboardService();

  DashboardModel? dashboardModel;
  bool isLoading = false;
  bool hasError = false;
  String? errorMessage;

  Future<void> getDashboard({String? month, String? year,String? token}) async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    notifyListeners();

    try {

      final response = await _dashboardService.getDashboard(
        month: month,
        year: year,
        token: token,
      );
      dashboardModel = response;
      print('091283120938091283 $response');
      print('109283109238120983 $errorMessage');
      print('109283109238120983 $hasError');

    } on DioException catch (e) {
      hasError = true;
      print('ERRO REAL: $e');          // ← adicione isso
      print('TIPO: ${e.runtimeType}');
      final data = e.response?.data;
      if (data is Map) {
        errorMessage = data['message'] as String?;
      }
      errorMessage ??= 'Não foi possível carregar os dados.';


    } catch (e) {
      hasError = true;
      print('ERRO REAL: $e');          // ← adicione isso
      print('TIPO: ${e.runtimeType}');
      errorMessage = 'Não foi possível carregar os dados.';

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    dashboardModel = null;
    isLoading = false;
    hasError = false;
    errorMessage = null;
    notifyListeners();
  }
}
