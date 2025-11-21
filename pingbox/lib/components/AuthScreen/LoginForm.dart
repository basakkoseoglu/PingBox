import 'package:flutter/material.dart';
import 'package:pingbox/components/Diaologs/CustomConfirmDialog.dart';
import 'package:pingbox/pages/MainScreen.dart';
import 'package:pingbox/providers/UserAuthProvider.dart';
import 'package:pingbox/services/PasswordSaveService.dart';
import 'package:pingbox/theme/AppColors.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

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
    final authProvider = context.watch<UserAuthProvider>();

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
            onPressed: authProvider.isLoading
                ? null
                : () async {
                    final email = loginEmailController.text.trim();
                    final password = loginPasswordController.text.trim();

                    // alan kontrol
                    if (email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Lütfen tüm alanları doldurun'),
                        ),
                      );
                      return;
                    }

                    final result = await context
                        .read<UserAuthProvider>()
                        .signIn(email: email, password: password);

                    if (result.isSuccess && mounted) {

                      final alreadyAccepted =await PasswordSaveService.isAcceptedBefore();

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

                      // Şifre kaydet veya sadece email kaydet
                      if (savePass == true) {
                        await PasswordSaveService.saveLoginInfo(
                          email: email,
                          password: password,
                        );
                      } else {
                        await PasswordSaveService.saveLoginInfo(email: email);
                      }

                      // Ana ekrana yönlendir
                      if (mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const MainScreen()),
                        );
                      }
                    } else if (mounted) {
                      // Giriş başarısız olursa hata göster
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              result.errorMessage ?? 'Giriş başarısız',
                            ),
                          ),
                        );
                      }
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: scheme.primary,
              foregroundColor: scheme.surface,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: authProvider.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Giriş Yap", style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
