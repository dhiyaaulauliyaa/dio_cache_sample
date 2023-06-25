import '../injection/service_locator.dart';
import 'layout.dart';
import 'messenger.dart';

mixin AppServicesMixin {
  static final _messenger = getIt<MessengerService>();
  static final _layout = getIt<LayoutService>();

  MessengerService get msg => _messenger;
  LayoutService get layout => _layout;
  DeviceScreenType get screenType => getIt<LayoutService>().screenType;
}

mixin MessengerServiceMixin {
  static final _messenger = getIt<MessengerService>();

  MessengerService get msg => _messenger;
}
