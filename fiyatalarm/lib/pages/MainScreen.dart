import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../components/BottomNavBar/CustomNavBar.dart';
import 'UpcomingMessagesScreen.dart';
import 'NotificationScreen.dart';
import 'ProfileScreen.dart';
import 'MessageComposeScreen.dart';

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
     NotificationScreen(),
    const ProfileScreen(),
  ];

  final List<IconData> _icons = [
    FontAwesomeIcons.alarmClock,
    FontAwesomeIcons.wandMagicSparkles,
    FontAwesomeIcons.bell,
    FontAwesomeIcons.user,
  ];
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