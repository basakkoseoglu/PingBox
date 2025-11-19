import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiyatalarm/firebase_options.dart';
import 'package:fiyatalarm/pages/SplashScreen.dart';
import 'package:fiyatalarm/providers/MessageProvider.dart';
import 'package:fiyatalarm/providers/UserAuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/AppTheme.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Background message: ${message.notification?.title}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // bildirim izni
  await FirebaseMessaging.instance.requestPermission();

  // background mesajları dinle
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  print("Firebase bağlantısı başarılı");

  // FCM token'ı sadece giriş yapılmışsa kaydet
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("Kullanıcı FCM Token: $fcmToken");

    if (fcmToken != null) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .set({
        "fcmToken": fcmToken,
        "updatedAt": DateTime.now(),
      }, SetOptions(merge: true));
    }
  }

  // uygulama ön planda iken mesajları dinle
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Foreground message: ${message.notification?.title}");
  });

  // bildirime tıklanma olayını dinle
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("Notification clicked: ${message.notification?.title}");
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserAuthProvider()..initialize()), 
        ChangeNotifierProvider(create: (_) => MessageProvider()..initializeStreams()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<UserAuthProvider>();  

    // Uygulama başlarken loading göster
    if (authProvider.isInitializing) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Yükleniyor...'),
              ],
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}