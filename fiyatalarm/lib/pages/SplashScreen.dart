import 'package:fiyatalarm/pages/AuthScreen.dart';
import 'package:fiyatalarm/pages/MainScreen.dart';
import 'package:fiyatalarm/providers/UserAuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // 2 saniye animasyon göster
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // UserAuthProvider'dan kullanıcı durumunu al
    final authProvider = context.read<UserAuthProvider>();

    if (authProvider.isAuthenticated) {
      // Kullanıcı giriş yapmış → MainScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    } else {
      // Kullanıcı giriş yapmamış → AuthScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/animations/Splash.json'),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
