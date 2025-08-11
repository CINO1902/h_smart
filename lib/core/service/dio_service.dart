import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/enum.dart';
import '../../constant/network_api.dart';
import '../exceptions/app_exceptions.dart';
import '../exceptions/exception_parser.dart';

import 'http_service.dart';

class DioService implements HttpService {
  final Dio dio;

  DioService(this.dio) {
    dio.options
      ..baseUrl = baseUrl
      ..connectTimeout = const Duration(seconds: 15)
      ..receiveTimeout = const Duration(seconds: 15)
      ..headers.addAll({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) '
            'AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.4 Safari/605.1.15',
      });

    if (kDebugMode) {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            log(
              'REQUEST[${options.method}] => PATH: ${options.path}'
              ' => QUERY: ${options.queryParameters}'
              ' => HEADERS: ${options.headers}',
            );
            handler.next(options);
          },
          onResponse: (response, handler) {
            log('RESPONSE[${response.statusCode}] => DATA: ${response.data}');
            handler.next(response);
          },
          onError: (err, handler) {
            log('ERROR[${err.response?.statusCode}] => ${err.message}');
            handler.next(err);
          },
        ),
      );
    }
  }

  @override
  Future<Response> request({
    required String url,
    required RequestMethod methodrequest,
    Map<String, dynamic>? params,
    CancelToken? cancelToken,
    dynamic data,
  }) async {
    // Base headers for all requests
    final baseHeaders = <String, String>{
      'Accept': 'application/json',
      'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) '
          'AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.4 Safari/605.1.15',
    };

    // Retrieve stored token if needed
    String? token;
    if (methodrequest == RequestMethod.getWithToken ||
        methodrequest == RequestMethod.postWithToken ||
        methodrequest == RequestMethod.putWithToken) {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('jwt_token');
    }

    // Build options based on method
    Options options;
    if (token != null && token.isNotEmpty) {
      options = Options(headers: {
        ...baseHeaders,
        'Authorization': 'Bearer $token',
      });
    } else {
      options = Options(headers: baseHeaders);
    }

    try {
      switch (methodrequest) {
        case RequestMethod.get:
          return await dio.get(
            url,
            queryParameters: params,
            cancelToken: cancelToken,
            options: options,
          );
        case RequestMethod.post:
          return await dio.post(
            url,
            data: data,
            cancelToken: cancelToken,
            options: options,
          );
        case RequestMethod.put:
          return await dio.put(
            url,
            data: data,
            queryParameters: params,
            cancelToken: cancelToken,
            options: options,
          );
        case RequestMethod.patch:
          return await dio.patch(
            url,
            data: data,
            cancelToken: cancelToken,
            options: options,
          );
        case RequestMethod.delete:
          return await dio.delete(
            url,
            cancelToken: cancelToken,
            options: options,
          );
        case RequestMethod.getWithToken:
          return await dio.get(
            url,
            queryParameters: params,
            cancelToken: cancelToken,
            options: options,
          );
        case RequestMethod.postWithToken:
          return await dio.post(
            url,
            data: data,
            cancelToken: cancelToken,
            options: options,
          );
        case RequestMethod.putWithToken:
          return await dio.put(
            url,
            data: data,
            queryParameters: params,
            cancelToken: cancelToken,
            options: options,
          );
      }
    } on DioException catch (e) {
      log(e.response.toString());
      if (e.response == null) {
        throw CustomException('Something went wrong');
      }
      throw parseNetworkException(e);
    }
  }

  @override
  set header(Map<String, dynamic> header) {
    dio.options.headers = header;
  }

  @override
  Future<Map<String, dynamic>> formdata({
    required String key,
    required String path,
    String? name,
  }) async {
    return {key: await MultipartFile.fromFile(path, filename: name)};
  }
}
