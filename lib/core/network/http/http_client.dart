import 'package:dio/dio.dart';

import '../network_url.dart';
import 'http_setting.dart';
import 'interceptors/log_http_interceptor.dart';

class HttpClient extends DioMixin {
  /* Private Instance */
  HttpClient._(HttpSetting settings) {
    options = BaseOptions(
      baseUrl: settings.baseUrl,
      contentType: settings.contentType,
      connectTimeout: Duration(milliseconds: settings.timeout.connectTimeout),
      sendTimeout: Duration(milliseconds: settings.timeout.sendTimeout),
      receiveTimeout: Duration(milliseconds: settings.timeout.receiveTimeout),
    );

    httpClientAdapter = HttpClientAdapter();

    interceptors.addAll(
      settings.interceptors ?? defaultInterceptors,
    );
  }

  /* Instance Getter */
  static HttpClient init([HttpSetting? settings]) {
    return HttpClient._(
      settings ?? HttpSetting(baseUrl: NetworkURL.base),
    );
  }

  /* Default Interceptors */
  static List<Interceptor> defaultInterceptors = [
    LogHttpInterceptor(),
  ];
}
