import 'package:fiyatalarm/pages/MainScreen.dart';
import 'package:fiyatalarm/services/UserService.dart';
import 'package:fiyatalarm/theme/AppColors.dart';
import 'package:flutter/material.dart';
import '../../services/AuthService.dart';
import '../../services/PasswordSaveService.dart';
import '../Diaologs/CustomConfirmDialog.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  final AuthService authService = AuthService();
  final UserService userService = UserService();

  bool isObscure = true;

  @override
  void initState() {
    super.initState();
    loadSavedInfo();
  }

  void loadSavedInfo() async {
    final saved = await PasswordSaveService.loadSavedInfo();
    loginEmailController.text = saved["email"] ?? "";
    loginPasswordController.text = saved["password"] ?? "";
  }

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
                borderSide: BorderSide(
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppColors.borderLight
                      : AppColors.borderDark,
                ),
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
              prefixIcon: Icon(Icons.lock, color: scheme.primary),
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
                borderSide: BorderSide(
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppColors.borderLight
                      : AppColors.borderDark,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final email = loginEmailController.text.trim();
              final password = loginPasswordController.text.trim();

              final user = await authService.signIn(email, password);

              if (user != null) {
                await userService.saveUserDeviceToken();
                final alreadyAccepted =
                    await PasswordSaveService.isAcceptedBefore();
                bool? savePass;
                if (!alreadyAccepted) {
                  savePass = await AppDialogs.show(
                    context,
                    title: 'Şifreni Kaydet',
                    message:
                        'Şifrenizi kaydetmek ister misiniz? Bir sonraki girişinizde otomatik doldurulacaktır.',
                    primaryButton: 'Kaydet',
                    secondaryButton: 'Şimdi Değil',
                  );
                }
                if (savePass == true) {
                  await PasswordSaveService.saveLoginInfo(
                    email: email,
                    password: password,
                  );
                } else {
                  await PasswordSaveService.saveLoginInfo(email: email);
                }
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MainScreen()),
                );
              }
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: scheme.primary,
              foregroundColor: scheme.surface,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text("Giriş Yap", style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
