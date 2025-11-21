import 'package:fiyatalarm/Models/QuietHours.dart';
import 'package:fiyatalarm/services/UserService.dart';

class QuietHoursService {
  static final UserService _userService = UserService();

  static Future<bool> updateQuietHours(QuietHours quietHours) async {
    try {
      await _userService.updateQuietHours(quietHours);
      return true;
    } catch (e) {
      print("QuietHours update error: $e");
      return false;
    }
  }

  static String getDurationText(QuietHours q) {
    final startMinutes = q.startTime.hour * 60 + q.startTime.minute;
    final endMinutes = q.endTime.hour * 60 + q.endTime.minute;

    int durationMinutes;
    if (startMinutes > endMinutes) {
      durationMinutes = (24 * 60 - startMinutes) + endMinutes;
    } else {
      durationMinutes = endMinutes - startMinutes;
    }

    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;

    if (minutes == 0) return '$hours saat boyunca bildirimler sessiz olacak';
    return '$hours saat $minutes dakika boyunca bildirimler sessiz olacak';
  }
}
