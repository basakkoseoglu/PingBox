import 'package:fiyatalarm/pages/MainScreen.dart';
import 'package:fiyatalarm/theme/AppColors.dart';
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
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            controller: loginEmailController,
            decoration: InputDecoration(
              labelText: "E-mail",
              prefixIcon: Icon(Icons.person, color: scheme.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
               borderSide: BorderSide( color: Theme.of(context).brightness == Brightness.light
            ? AppColors.borderLight
            : AppColors.borderDark,),
              borderRadius: BorderRadius.circular(12),
            ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: loginPasswordController,
            obscureText: isObscure,
            decoration: InputDecoration(
              labelText: "Şifre",
              prefixIcon: Icon( Icons.lock, color: scheme.primary),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() => isObscure = !isObscure);
                },
                icon: Icon(
                  isObscure ? Icons.visibility_off : Icons.visibility,
                  color: scheme.onPrimary,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
              borderSide: BorderSide( color: Theme.of(context).brightness == Brightness.light
            ? AppColors.borderLight
            : AppColors.borderDark,),
              borderRadius: BorderRadius.circular(12),
            ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final user = await authService.signIn(
                loginEmailController.text.trim(),
                loginPasswordController.text.trim(),
              );
              if (user != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: scheme.primary,
              foregroundColor: scheme.surface,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text(
              "Giriş Yap",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
