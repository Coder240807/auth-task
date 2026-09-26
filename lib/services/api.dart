import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Api {
  final dio = Dio();
  Future<Map<String, dynamic>> postData(
    String username,
    String password,
  ) async {
    try {
      Response response = await dio.post(
        'https://dummyjson.com/auth/login',
        data: {'username': username, 'password': password},
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception('Error $e');
    }
  }

  Future<Map<String, dynamic>> getData(String token) async {
    try {
      Response response = await dio.get(
        'https://dummyjson.com/auth/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception('Error $e');
    }
  }
}
