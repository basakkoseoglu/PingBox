import 'package:fiyatalarm/pages/MainScreen.dart';
import 'package:flutter/material.dart';
import '../../services/AuthService.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  final AuthService authService = AuthService();

  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            controller: loginEmailController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              labelText: "E-mail",
              prefixIcon: Icon(Icons.person),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: loginPasswordController,
            obscureText: isObscure,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              labelText: "Şifre",
              prefixIcon: Icon(Icons.lock),
              suffixIcon: IconButton(
                onPressed: () => setState(() => isObscure = !isObscure),
                icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final user = await authService.signIn(
                loginEmailController.text.trim(),
                loginPasswordController.text.trim(),
              );
              if (user != null) {
                print("Giriş Başarılı");
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                );
              }
            },
            child: const Text(
              "Giriş Yap",
              style: TextStyle(fontSize: 18,color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }
}
