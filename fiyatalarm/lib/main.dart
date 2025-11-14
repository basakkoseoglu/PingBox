import 'package:firebase_core/firebase_core.dart';
import 'package:fiyatalarm/firebase_options.dart';
import 'package:flutter/material.dart';
import 'pages/AuthScreen.dart';
import 'pages/MainScreen.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
print("firebase bağlantısı başarılı");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, 
      ),
      home:MainScreen(),
    );
  }
}