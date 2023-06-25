import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../injection/service_locator.dart';

abstract class ConnectionInfo {
  Future<bool> get isConnected;
}

@LazySingleton(as: ConnectionInfo)
class ConnectionInfoImpl implements ConnectionInfo {
  final connectionChecker = getIt<InternetConnectionCheckerPlus>();

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
