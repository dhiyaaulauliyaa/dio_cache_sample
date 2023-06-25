import '../injection/service_locator.dart';
import 'messenger.dart';

mixin AppServicesMixin {
  static final _messenger = getIt<MessengerService>();

  MessengerService get msg => _messenger;
}

mixin MessengerServiceMixin {
  static final _messenger = getIt<MessengerService>();

  MessengerService get msg => _messenger;
}
