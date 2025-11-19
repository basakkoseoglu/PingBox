import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationPermissionScreen extends StatefulWidget {
  const NotificationPermissionScreen({super.key});

  @override
  State<NotificationPermissionScreen> createState() => _NotificationPermissionScreenState();
}

class _NotificationPermissionScreenState extends State<NotificationPermissionScreen> with WidgetsBindingObserver {
  bool _isNotificationEnabled = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkNotificationPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkNotificationPermission();
    }
  }

  Future<void> _checkNotificationPermission() async {
    setState(() => _isLoading = true);
    
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.getNotificationSettings();
      
      setState(() {
        _isNotificationEnabled = settings.authorizationStatus == AuthorizationStatus.authorized;
        _isLoading = false;
      });

      print('📱 Firebase Bildirim durumu: ${settings.authorizationStatus}');
    } catch (e) {
      print('Kontrol hatası: $e');
      final status = await Permission.notification.status;
      setState(() {
        _isNotificationEnabled = status.isGranted;
        _isLoading = false;
      });
    }
  }

  Future<void> _requestNotificationPermission() async {
    print('İzin isteme başladı...');
    
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      print(' Firebase sonuç: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        setState(() => _isNotificationEnabled = true);
        _showSnackBar('Bildirim izni verildi ✓', Colors.green);
      } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
        _showPermissionDeniedDialog();
      } else if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
        print('🔄 Permission handler ile tekrar deneniyor...');
        final status = await Permission.notification.request();
        
        if (status.isGranted) {
          setState(() => _isNotificationEnabled = true);
          _showSnackBar('Bildirim izni verildi ✓', Colors.green);
        } else if (status.isPermanentlyDenied) {
          _showPermissionDeniedDialog();
        } else {
          _showSnackBar('Bildirim izni reddedildi', Colors.orange);
        }
      }
    } catch (e) {
      print('İzin isteme hatası: $e');
      _showSnackBar('Bir hata oluştu', Colors.red);
    }

    // Son durumu kontrol et
    await _checkNotificationPermission();
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bildirim İzni Gerekli'),
        content: const Text(
          'Bildirim izni vermek için lütfen uygulama ayarlarına gidin ve bildirimleri açın.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
            },
            child: const Text('Ayarlara Git'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Bildirim İzinleri',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: _isNotificationEnabled
                            ? colorScheme.primary.withOpacity(0.1)
                            : colorScheme.error.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isNotificationEnabled
                            ? Icons.notifications_active
                            : Icons.notifications_off,
                        size: 60,
                        color: _isNotificationEnabled
                            ? colorScheme.primary
                            : colorScheme.error,
                      ),
                    ),

                    const SizedBox(height: 32),

                    Text(
                      _isNotificationEnabled
                          ? 'Bildirimler Açık'
                          : 'Bildirimler Kapalı',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      _isNotificationEnabled
                          ? 'Mesajlarınızı tam vaktinde alacaksınız.'
                          : 'Mesajlarınızı tam vaktinde almak için bildirimleri açmanızı öneririz.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: colorScheme.onSurface.withOpacity(0.7),
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _isNotificationEnabled 
                            ? () async {
                                await openAppSettings();
                              }
                            : _requestNotificationPermission,
                        icon: Icon(
                          _isNotificationEnabled
                              ? Icons.settings
                              : Icons.notifications_active,
                        ),
                        label: Text(
                          _isNotificationEnabled
                              ? 'Bildirim Ayarlarına Git'
                              : 'Bildirimleri Aç',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextButton.icon(
                      onPressed: _checkNotificationPermission,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Durumu Kontrol Et'),
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.primary,
                      ),
                    ),

                    const SizedBox(height: 60),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: colorScheme.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Bildirimleri istediğiniz zaman telefon ayarlarından kapatabilirsiniz.',
                              style: TextStyle(
                                fontSize: 13,
                                color: colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }
}