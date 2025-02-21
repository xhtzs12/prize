import 'package:dio/dio.dart';

class HttpUtils {
  static final HttpUtils _instance = HttpUtils._internal();
  factory HttpUtils() => _instance;

  late Dio _dio;

  HttpUtils._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: '',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    _dio = Dio(options);

    // 添加拦截器
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Authorization'] = 'Bearer token';
        return handler.next(options);
      },
      onResponse: (response, handler) {
        if (response.statusCode == 200) {
          return handler.next(response);
        } else {
          return handler.reject(DioException(
              requestOptions: response.requestOptions, response: response));
        }
      },
      onError: (DioException error, handler) {
        return handler.next(error);
      },
    ));
  }

  Future<Response> get(String path, {Map<String, dynamic>? params}) async {
    return await _dio.get(path, queryParameters: params);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }

  Future<Response> delete(String path, {dynamic data}) async {
    return await _dio.delete(path, data: data);
  }
}
