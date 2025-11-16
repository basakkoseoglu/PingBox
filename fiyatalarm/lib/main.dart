import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  print("Background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.requestPermission();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  print("firebase bağlantısı başarılı");

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
