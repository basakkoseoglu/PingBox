import 'package:fiyatalarm/services/NotificationPermissionService.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationPermissionProvider extends ChangeNotifier {
  bool isLoading = true;
  bool isEnabled = false;

  NotificationPermissionProvider() {
    loadStatus();
  }

  Future<void> loadStatus() async {
    isLoading = true;
    notifyListeners();

    isEnabled = await NotificationPermissionService.isEnabled();

    isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadStatus();
  }

  Future<AuthorizationStatus> requestPermission() async {
    final status = await NotificationPermissionService.requestPermission();
    await loadStatus();
    return status;
  }
}
