import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:injectable/injectable.dart';

import '../utils/log.dart';

enum DeviceScreenType {
  sm('sm'),
  md('md'),
  lg('lg'),
  xl('xl'),
  xxl('xxl');

  final String name;
  const DeviceScreenType(this.name);

  bool get isSm => name == 'sm';
  bool get isMd => name == 'md';
  bool get isLg => name == 'lg';
  bool get isXl => name == 'xl';
  bool get isXxl => name == 'xxl';

  double get breakpoint {
    switch (name) {
      case 'sm':
        return 640;
      case 'md':
        return 768;
      case 'lg':
        return 1024;
      case 'xl':
        return 1280;
      case 'xxl':
        return 1536;
      default:
        return 640;
    }
  }
}

@LazySingleton()
class LayoutService {
  DeviceScreenType _screenType = DeviceScreenType.sm;
  DeviceScreenType get screenType => _screenType;
  void setScreenType(DeviceScreenType type) {
    Log.warning(
      '$type',
      type: 'Screen Type',
    );

    _screenType = type;
  }

  DeviceScreenType getScreenType(double screenWidth) {
    if (screenWidth > DeviceScreenType.xxl.breakpoint) {
      return DeviceScreenType.xxl;
    } else if (screenWidth > DeviceScreenType.xl.breakpoint) {
      return DeviceScreenType.xl;
    } else if (screenWidth > DeviceScreenType.lg.breakpoint) {
      return DeviceScreenType.lg;
    } else if (screenWidth > DeviceScreenType.md.breakpoint) {
      return DeviceScreenType.md;
    } else {
      return DeviceScreenType.sm;
    }
  }

  double sizer({
    /// Size in sm. fallback to 0 if null
    double? sm,

    /// Size in md. fallback to sm if null
    double? md,

    /// Size in lg. fallback to md if null
    double? lg,

    /// Size in xl. fallback to lg if null
    double? xl,

    /// Size in xxl. fallback to xl if null
    double? xxl,

    /// Set if integer or not. Default data type is double
    bool integer = false,

    /// Implement screenUtil on mobile. Default is true.
    bool useScreenUtilOnMobile = true,
  }) {
    var def = xxl ?? xl ?? lg ?? md ?? sm ?? 0;

    switch (_screenType) {
      case DeviceScreenType.sm:
        var val = sm;
        if (useScreenUtilOnMobile) val = val?.h;
        return sm ?? def;
      case DeviceScreenType.md:
        return md ?? def;
      case DeviceScreenType.lg:
        return lg ?? def;
      case DeviceScreenType.xl:
        return xl ?? def;
      case DeviceScreenType.xxl:
        return xxl ?? def;
    }
  }

  /// Sizer but allow null value.
  double? nullableSizer({
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    bool integer = false,
    bool useScreenUtilOnMobile = true,
  }) {
    var size = sizer(
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      xxl: xxl,
      integer: integer,
      useScreenUtilOnMobile: useScreenUtilOnMobile,
    );

    if (size == 0) {
      return null;
    }

    return size;
  }
}
