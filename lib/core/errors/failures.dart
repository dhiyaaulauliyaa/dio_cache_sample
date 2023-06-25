import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure({
    required this.message,
    this.code = '',
  });

  final String message;
  final String code;

  @override
  List<Object?> get props => <Object?>[message, code];

  @override
  String toString() => '[$code] $message';
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    String message = 'Oops! looks like you have connection problem',
  }) : super(message: message);
}

class ServerFailure extends Failure {
  const ServerFailure({
    required String message,
    required String code,
  }) : super(
          message: message,
          code: code,
        );
}

class ClientFailure extends Failure {
  const ClientFailure({
    String code = 'CF404',
    String? message,
  }) : super(
          message: message ??
              'Oops! Client error: $code. '
                  'Report to support centre. ',
          code: code,
        );
}
