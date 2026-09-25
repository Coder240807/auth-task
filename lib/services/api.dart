import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Api {
  Future<Map<String, dynamic>> postData(
    String username,
    String password,
  ) async {
    final dio = Dio();
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
}
