class NetworkException implements Exception {
  NetworkException(
    String? message,
  ) : message = message ?? 'Oops! looks like you have connection problem';

  final String message;

  @override
  String toString() => '[NE200] $message';
}

class ServerException implements Exception {
  ServerException({
    String? message,
    String? code,
  })  : message = message ??
            'Oops! Server error, please try again later. '
                '[$code]',
        code = 'SE404';

  final String message;
  final String code;

  @override
  String toString() => '[$code] $message';
}

class RequestException implements Exception {
  RequestException({
    String? message,
    String? code,
  })  : message = message ??
            'Oops! Request error: $code. '
                'Report to support centre. ',
        code = 'RE404';

  final String message;
  final String code;

  @override
  String toString() => '[$code] $message';
}

class ClientException implements Exception {
  ClientException({
    String? message,
    String? code,
  })  : message = message ??
            'Oops! Client error: $code. '
                'Report to support centre. ',
        code = 'CE404';

  final String message;
  final String code;

  @override
  String toString() => '[$code] $message';
}
