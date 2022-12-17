import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

enum WorkOrderStatus { waiting, ongoing, finished, cancelled }

extension WorkOrderStatusExtension on WorkOrderStatus {
  static WorkOrderStatus? fromString(String value) {
    if (value == WorkOrderStatus.waiting.name) {
      return WorkOrderStatus.waiting;
    } else if (value == WorkOrderStatus.ongoing.name) {
      return WorkOrderStatus.ongoing;
    } else if (value == WorkOrderStatus.finished.name) {
      return WorkOrderStatus.finished;
    } else if (value == WorkOrderStatus.cancelled.name) {
      return WorkOrderStatus.cancelled;
    } else {
      return null;
    }
  }

  Color color(BuildContext context) {
    var currentThemeMode = AdaptiveTheme.of(context).brightness;

    switch (this) {
      case WorkOrderStatus.waiting:
        return (currentThemeMode == Brightness.light)
            ? const Color.fromARGB(255, 255, 242, 121)
            : const Color.fromARGB(255, 128, 118, 31);
      case WorkOrderStatus.ongoing:
        return (currentThemeMode == Brightness.light)
            ? const Color.fromARGB(255, 123, 199, 125)
            : const Color.fromARGB(255, 67, 112, 69);
      case WorkOrderStatus.finished:
        return (currentThemeMode == Brightness.light)
            ? const Color.fromARGB(255, 185, 185, 185)
            : const Color.fromARGB(255, 97, 97, 97);
      case WorkOrderStatus.cancelled:
        return (currentThemeMode == Brightness.light)
            ? const Color.fromARGB(255, 255, 129, 120)
            : const Color.fromARGB(255, 159, 70, 64);
      default:
        return Colors.transparent;
    }
  }
}
