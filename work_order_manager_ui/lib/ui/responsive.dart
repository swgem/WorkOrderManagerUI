import 'package:flutter/material.dart';

enum Platform { mobile, tablet, desktop }

abstract class Responsive {
  static Platform platform(BuildContext context) {
    if (MediaQuery.of(context).size.width < 680) {
      return Platform.mobile;
    } else if (MediaQuery.of(context).size.width < 1100 &&
        MediaQuery.of(context).size.width >= 680) {
      return Platform.tablet;
    } else /*if (MediaQuery.of(context).size.width >= 1100)*/ {
      return Platform.desktop;
    }
  }
}
