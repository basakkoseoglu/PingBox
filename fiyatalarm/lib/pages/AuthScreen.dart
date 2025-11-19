import 'package:fiyatalarm/components/AuthScreen/LoginForm.dart';
import 'package:fiyatalarm/components/AuthScreen/RegisterForm.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthScreen> with SingleTickerProviderStateMixin {
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
    final scheme = Theme.of(context).colorScheme;
    final textScheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            children: [
              SizedBox(height: 50),
              Image.asset('assets/logo/denme.png' ,fit: BoxFit.contain,),
              SizedBox(height: 20),

              TabBar(
                controller: _tabController,
                indicatorColor: scheme.primary,
                labelColor: scheme.primary,
                unselectedLabelColor: textScheme.bodyMedium!.color,
                tabs: const [
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
