import 'package:dartz/dartz.dart';

import '../errors/exceptions.dart';
import '../errors/failures.dart';
import '../injection/service_locator.dart';
import '../network/connection_info.dart';
import '../utils/log.dart';

mixin RepositoryMixin {
  final networkInfo = getIt<ConnectionInfo>();

  Future<Either<Failure, T>> callRemoteDataSource<T>(
    Future<T> Function() call,
  ) async {
    if (!(await networkInfo.isConnected)) return const Left(NetworkFailure());
    
    try {
      T result = await call();

      return Right(result);
    } on ClientException catch (e) {
      return Left(ClientFailure(message: e.message, code: e.code));
    } on RequestException catch (e) {
      return Left(ClientFailure(message: e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      Log.error('Unknown error when call remote datasource', type: 'Err');
      return const Left(ClientFailure(code: 'CF202'));
    }
  }
}
