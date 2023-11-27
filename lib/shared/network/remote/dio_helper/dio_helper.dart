import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    String baseUrl = 'https://api.pexels.com/';

    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        responseType: ResponseType.json,
        headers: {
          'Content-Type': 'application/json',
        },
        validateStatus: (status) {
          return (status! <= 505);
        },
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': '$token',
    };
    return dio.get(url, queryParameters: query);
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    String? token,
  }) {
    dio.options.headers = {
      'Authorization': 'token',
      "Content-Type": "application/json",
    };

    return dio.post(url, queryParameters: query, data: data);
  }

  static Future<Response> putData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    String? token,
  }) {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token',
    };

    return dio.put(url, queryParameters: query, data: data);
  }
}