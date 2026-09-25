import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Api {
  Future<void> getData() async {
    var dio = Dio();
    try {
      Response response = await dio.get('https://dummyjson.com/auth/login');
      print(response.data); // Handle the response
    } catch (e) {
      print('Error: $e');
    }
  }
}
