import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiService {
  static final ApiService _instance = ApiService.internal();

  factory ApiService() => _instance;

  ApiService.internal();

  String url     = "http://10.0.2.2:3000";
  String fileUrl = "https://fileupload-dot-cashedu.uc.r.appspot.com";

  // ── Opções padrão ─────────────────────────
  Options _options(Map<String, dynamic>? customHeader) => Options(
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      ...?customHeader,
    },
  );

  // ── GET ───────────────────────────────────
  Future<Map<String, dynamic>> get({
    @required String? query,
    Map<String, dynamic>? customHeader,
    bool fromFileApi = false,
    Duration duration = const Duration(seconds: 10),
  }) async {
    final currentUrl = (fromFileApi ? fileUrl : url) + query!;
    print(currentUrl);

    // DioException é relançada automaticamente — catch fica na tela
    final response = await Dio()
        .get(currentUrl, options: _options(customHeader))
        .timeout(duration);

    if (response.data is List) return {"data": response.data};
    return response.data as Map<String, dynamic>;
  }

  // ── POST ──────────────────────────────────
  Future<Map<String, dynamic>> post({
    @required String? query,
    @required Map<String, dynamic>? body,
    Map<String, dynamic>? customHeader,
    bool fromFileApi = false,
    Duration duration = const Duration(seconds: 30),
  }) async {
    final currentUrl = (fromFileApi ? fileUrl : url) + query!;
    print(currentUrl);
    print(body);

    final response = await Dio()
        .post(
      currentUrl,
      data: jsonEncode(body ?? {}),
      options: _options(customHeader),
    )
        .timeout(duration);

    if (response.data is List) return {"data": response.data};
    return response.data as Map<String, dynamic>;
  }

  // ── PUT ───────────────────────────────────
  Future<Map<String, dynamic>> put({
    @required String? query,
    @required Map<String, dynamic>? body,
    Map<String, dynamic>? customHeader,
    bool fromFileApi = false,
    Duration duration = const Duration(seconds: 10),
  }) async {
    final currentUrl = (fromFileApi ? fileUrl : url) + query!;
    print(currentUrl);
    print(body);

    final response = await Dio()
        .put(
      currentUrl,
      data: jsonEncode(body ?? {}),
      options: _options(customHeader),
    )
        .timeout(duration);

    if (response.data is List) return {"data": response.data};
    return response.data as Map<String, dynamic>;
  }
}
