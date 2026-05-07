import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;

  ApiClient() : dio = Dio(BaseOptions(baseUrl: 'https://fakestoreapi.com')) {
    // Syarat ETS: Wajib menggunakan interceptor logger
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      responseBody: true, // Akan mencetak respon API di terminal
      error: true,
    ));
  }
}