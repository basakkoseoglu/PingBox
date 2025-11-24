import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pingbox/components/BottomNavBar/CustomNavBar.dart';
import 'package:pingbox/components/Diaologs/CustomConfirmDialog.dart';
import 'package:pingbox/pages/AIHomeScreen.dart';
import 'package:pingbox/pages/MessageComposeScreen.dart';
import 'package:pingbox/pages/NotificationScreen.dart';
import 'package:pingbox/pages/ProfileScreen.dart';
import 'package:pingbox/pages/UpcomingMessagesScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const UpComingMessagesScreen(),
    const MessageComposeScreen(),
    const AIHomeScreen(),
    const NotificationScreen(),
    const ProfileScreen(),
  ];

  final List<IconData> _icons = [
    FontAwesomeIcons.alarmClock,
    FontAwesomeIcons.wandMagicSparkles,
     Icons.abc,
    FontAwesomeIcons.bell,
    FontAwesomeIcons.user,
  ];

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground Bildirim Geldi!");

      String title = message.notification?.title ?? "Bildirim";
      String body = message.notification?.body ?? "Mesajın var.";

      if (mounted) {
        AppDialogs.show(
          context,
          title: title,
          message: body,
          primaryButton: "Tamam",
          secondaryButton: null,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTapChange: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        icons: _icons,
      ),
    );
  }
}
