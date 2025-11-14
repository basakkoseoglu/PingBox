import 'package:flutter/material.dart';
import '../components/AuthScreen/LoginForm.dart';
import '../components/AuthScreen/RegisterForm.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            children: [
              SizedBox(height: 50),
              Image.asset(
                'assets/logo/alarmlogo.png',
                width: 150,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),

              TabBar(
                controller: _tabController,
                indicatorColor: Colors.blue,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.black54,
                tabs: [
                  Tab(text: "Giriş Yap"),
                  Tab(text: "Kayıt Ol"),
                ],
              ),

              SizedBox(
                height: 400,
                child: TabBarView(
                  controller: _tabController,
                  children: [LoginForm(), RegisterForm()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
