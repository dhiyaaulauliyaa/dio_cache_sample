import 'package:injectable/injectable.dart';

import '../../../injection/service_locator.dart';
import '../http_client.dart';
import '../http_module.dart';

@LazySingleton()
class BaseHttpModule extends HttpModule {
  BaseHttpModule()
      : super(
          getIt<HttpClient>(instanceName: 'baseHttpClient'),
        );

  @override
  Future<String> get authorizationToken async {
    return 'Bearer dummyToken';
  }
}
