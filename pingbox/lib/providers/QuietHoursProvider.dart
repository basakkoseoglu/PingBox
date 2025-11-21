import 'package:flutter/material.dart';
import 'package:pingbox/Models/QuietHours.dart';
import 'package:pingbox/services/QuietHoursService.dart';

class QuietHoursProvider extends ChangeNotifier {
  QuietHours quietHours;
  bool isLoading = false;

  QuietHoursProvider(this.quietHours);

  void toggleEnabled(bool enabled) {
    quietHours = quietHours.copyWith(enabled: enabled);
    notifyListeners();
  }

  void updateStart(TimeOfDay time) {
    quietHours = quietHours.copyWith(startTime: time);
    notifyListeners();
  }

  void updateEnd(TimeOfDay time) {
    quietHours = quietHours.copyWith(endTime: time);
    notifyListeners();
  }

  Future<bool> save() async {
    isLoading = true;
    notifyListeners();

    final success = await QuietHoursService.updateQuietHours(quietHours);

    isLoading = false;
    notifyListeners();

    return success;
  }

  String get durationText => QuietHoursService.getDurationText(quietHours);
  String get warningText => quietHours.getDisplayText();
}
