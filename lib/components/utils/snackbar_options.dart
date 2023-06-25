import 'package:flutter/material.dart';

enum SnackBarPosition { top, bottom }

enum SnackBarVariant {
  success('success'),
  error('error'),
  warning('warning'),
  neutral('neutral');

  const SnackBarVariant(this.name);
  final String name;

  Color get backgroundColor {
    switch (this) {
      case SnackBarVariant.success:
        return Colors.green;
      case SnackBarVariant.error:
        return Colors.red;
      case SnackBarVariant.warning:
        return Colors.yellow;
      case SnackBarVariant.neutral:
        return Colors.white;
    }
  }

  Color get borderColor {
    switch (this) {
      case SnackBarVariant.success:
        return Colors.greenAccent;
      case SnackBarVariant.error:
        return Colors.redAccent;
      case SnackBarVariant.warning:
        return Colors.yellowAccent;
      case SnackBarVariant.neutral:
        return Colors.white;
    }
  }

  Color get textColor {
    switch (this) {
      case SnackBarVariant.success:
        return Colors.white;
      case SnackBarVariant.error:
        return Colors.white;
      case SnackBarVariant.warning:
        return Colors.black;
      case SnackBarVariant.neutral:
        return Colors.black;
    }
  }
}
