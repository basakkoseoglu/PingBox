import 'package:flutter/material.dart';

class QuietHours {
  final bool enabled;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  QuietHours({
    this.enabled = false,
    this.startTime = const TimeOfDay(hour: 0, minute: 0),
    this.endTime = const TimeOfDay(hour: 8, minute: 0),
  });

  factory QuietHours.fromMap(Map<String, dynamic>? map) {
    if (map == null) return QuietHours();
    
    return QuietHours(
      enabled: map['enabled'] ?? false,
      startTime: TimeOfDay(
        hour: map['startHour'] ?? 0,
        minute: map['startMinute'] ?? 0,
      ),
      endTime: TimeOfDay(
        hour: map['endHour'] ?? 8,
        minute: map['endMinute'] ?? 0,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'enabled': enabled,
      'startHour': startTime.hour,
      'startMinute': startTime.minute,
      'endHour': endTime.hour,
      'endMinute': endTime.minute,
    };
  }

  QuietHours copyWith({
    bool? enabled,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) {
    return QuietHours(
      enabled: enabled ?? this.enabled,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  //  Belirli bir zamanın sessiz saatler içinde olup olmadığını kontrol et
  bool isInQuietHours(DateTime checkTime) {
    if (!enabled) return false;

    final checkMinutes = checkTime.hour * 60 + checkTime.minute;
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;

    // Gece yarısını geçen durumlar için (örn: 22:00 - 08:00)
    if (startMinutes > endMinutes) {
      return checkMinutes >= startMinutes || checkMinutes < endMinutes;
    } else {
      // Normal durumlar (örn: 14:00 - 16:00)
      return checkMinutes >= startMinutes && checkMinutes < endMinutes;
    }
  }

  // Sessiz saatler bittiğinde bildirim gönderilebilir mi
  DateTime? getNextAvailableTime(DateTime now) {
    if (!enabled) return now;
    
    if (!isInQuietHours(now)) return now;

    // Sessiz saatlerin bitme zamanını hesapla
    DateTime endDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      endTime.hour,
      endTime.minute,
    );

    // Eğer bitiş zamanı başlangıçtan önceyse (gece yarısını geçiyorsa)
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;
    
    if (startMinutes > endMinutes && now.hour >= startTime.hour) {
      // Ertesi güne geç
      endDateTime = endDateTime.add(const Duration(days: 1));
    }

    return endDateTime;
  }

  String getDisplayText() {
    final start = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    final end = '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
    return '$start - $end';
  }
}