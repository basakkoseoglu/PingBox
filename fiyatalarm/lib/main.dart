import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiyatalarm/firebase_options.dart';
import 'package:fiyatalarm/pages/SplashScreen.dart';
import 'package:flutter/material.dart';

import 'pages/AuthScreen.dart';
import 'pages/MainScreen.dart';
import 'theme/AppTheme.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("🔵 Background message: ${message.notification?.title}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🔥 Bildirim izni iste
  await FirebaseMessaging.instance.requestPermission();

  // 🔥 Background mesaj dinleyicisi
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  print("Firebase bağlantısı başarılı");

  // 🔥 Kullanıcıyı al
  final user = FirebaseAuth.instance.currentUser;

  // 🔥 FCM Token al ve kullanıcıya kaydet
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("📌 Kullanıcı FCM Token: $fcmToken");

  if (user != null && fcmToken != null) {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .set({
      "fcmToken": fcmToken,
    }, SetOptions(merge: true));
  }

  // 🔥 Uygulama AÇIKKEN bildirim alma
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("🔴 Foreground message: ${message.notification?.title}");
  });

  // 🔥 Bildirime tıklanınca
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("🟢 Notification clicked: ${message.notification?.title}");
  });

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: SplashScreen(),
    );
  }
}
