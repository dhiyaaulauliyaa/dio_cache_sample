import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';

import '../../errors/exceptions.dart';
import '../../utils/log.dart';
import 'http_client.dart';

abstract class HttpModule {
  HttpModule(HttpClient client) {
    _client = client;
  }

  @protected
  late HttpClient _client;

  Future<Map<String, dynamic>> get defaultHeaders async => {
        'Content-Type': 'application/json',
      };

  Future<String> get authorizationToken => Future.value('');
  Future<Map<String, String>> get authorizationHeaders async => {
        'Authorization': await authorizationToken,
        'Content-Type': 'application/json',
      };

  Future<dynamic> _executeRequest<T>(
    Future<Response<T>> call,
  ) async {
    try {
      var response = await call;
      return responseParser(response);
    } on DioException catch (dioErr) {
      String? message;
      int? code = dioErr.response?.statusCode;

      Log.error('Dio Error [${dioErr.type}]', type: 'Err');
      Log.soft(message, type: 'Err');

      List<DioExceptionType> dioTimeout = [
        DioExceptionType.connectionTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.sendTimeout,
      ];

      if (dioTimeout.any((e) => dioErr.type == e)) {
        throw NetworkException(message);
      }

      if (code == null) throw ClientException();

      if (code >= 500) {
        throw ServerException(message: message, code: code.toString());
      }
      if (code >= 400) {
        throw RequestException(message: message, code: code.toString());
      }

      throw ClientException(message: message, code: code.toString());
    } catch (e) {
      var message = 'Unknown Http error: $e';
      Log.error(message, type: 'Err');
      throw ClientException(message: message);
    }
  }

  dynamic responseParser(Response response) {
    try {
      return response.data is List
          ? (response.data as List)
              .map((e) => json.decode(e.toString()) as Map<String, dynamic>)
              .toList()
          : json.decode(response.toString()) as Map<String, dynamic>;
    } catch (e) {
      Log.warning('Parse Error', type: 'RESP');
      Log.soft(
        'Response format isn\'t as expected | ${response.realUri}',
        type: 'RESP',
      );
      Log.divider();

      throw ClientException(
        message: 'Failed to parse response',
        code: 'CE001',
      );
    }
  }

  Future<Map<String, dynamic>> getMethod(
    String endpoint, {
    Map<String, dynamic>? param,
    bool needAuthorization = true,
    bool cache = false,
    void Function(int, int)? onReceiveProgress,
  }) async {
    late Options options;
    /* Set Cache Options */
    options = cache
        ? CacheOptions(
            store: MemCacheStore(),
            maxStale: const Duration(days: 1),
          ).toOptions()
        : Options();

    /* Set Headers */
    options = options.copyWith(
      headers:
          needAuthorization ? await authorizationHeaders : await defaultHeaders,
    );

    var response = await _executeRequest(
      _client.get(
        endpoint,
        queryParameters: param,
        options: options,
        onReceiveProgress: onReceiveProgress,
      ),
    );

    return response;
  }

  Future<Map<String, dynamic>> postMethod(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? param,
    bool needAuthorization = true,
  }) async {
    var options = Options(headers: await defaultHeaders);
    options = options.copyWith(
      headers:
          needAuthorization ? await authorizationHeaders : await defaultHeaders,
    );

    var response = await _executeRequest(
      _client.post(
        endpoint,
        data: body,
        queryParameters: param,
        options: options,
      ),
    );

    return response;
  }

  Future<Map<String, dynamic>> putMethod(
    String endpoint, {
    dynamic body,
    bool needAuthorization = true,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    var options = Options(headers: await defaultHeaders);

    var response = await _executeRequest(
      _client.put(
        endpoint,
        data: body,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );

    return response;
  }

  Future<Map<String, dynamic>> deleteMethod(
    String endpoint, {
    Map<String, dynamic>? body,
    bool needAuthorization = true,
  }) async {
    var options = Options(headers: await defaultHeaders);

    var response = await _executeRequest(
      _client.delete(
        endpoint,
        data: body,
        options: options,
      ),
    );

    return response;
  }

  Future<Map<String, dynamic>> patchMethod(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? param,
    bool needAuthorization = true,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    var options = Options(headers: await defaultHeaders);

    var response = await _executeRequest(
      _client.patch(
        endpoint,
        data: body,
        queryParameters: param,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );

    return response;
  }
}
