import 'dart:core';
import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

class DioHelper {
  static final DioHelper _instance = DioHelper._internal();
  late final Dio dio;
  final FlutterSecureStorage _flutterSecureStorage = FlutterSecureStorage();

  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';

  factory DioHelper() => _instance;

  DioHelper._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://dummyjson.com',
        connectTimeout: const Duration(milliseconds: 5000),
        receiveTimeout: const Duration(milliseconds: 3000),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await _flutterSecureStorage.read(
            key: _keyAccessToken,
          );
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshToken = await _flutterSecureStorage.read(
              key: _keyRefreshToken,
            );
            if (refreshToken != null) {
              try {
                final newAccessToken = await _refreshAccessToken(refreshToken);

                final options = error.requestOptions;
                options.headers['Authorization'] = 'Bearer $newAccessToken';

                final response = await dio.fetch(options);
                return handler.resolve(response);
              } catch (e) {
                await clearTokens();
                return handler.next(error);
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _flutterSecureStorage.write(key: _keyAccessToken, value: accessToken);
    await _flutterSecureStorage.write(
      key: _keyRefreshToken,
      value: refreshToken,
    );
  }

  Future<void> clearTokens() async {
    await _flutterSecureStorage.delete(key: _keyAccessToken);
    await _flutterSecureStorage.delete(key: _keyRefreshToken);
  }

  Future<bool> hasToken() async {
    final token = await _flutterSecureStorage.read(key: _keyAccessToken);
    return token != null;
  }

  Future<String> _refreshAccessToken(String refreshToken) async {
    final tokenDio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));

    final response = await tokenDio.post(
      '/auth/refresh',
      data: {'refreshToken': refreshToken, 'expiresInMins': 5},
    );

    final newAccessToken = response.data['accessToken'] as String;
    final newRefreshToken = response.data['refreshToken'] as String;

    await saveTokens(
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
    );

    return newAccessToken;
  }
}
