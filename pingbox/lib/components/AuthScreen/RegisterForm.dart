import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pingbox/pages/MainScreen.dart';
import 'package:pingbox/providers/UserAuthProvider.dart';
import 'package:pingbox/theme/AppColors.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool isObscure = true;

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController regEmailController = TextEditingController();
  final TextEditingController regPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final authProvider = context.watch<UserAuthProvider>();
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            controller: userNameController,
            decoration: InputDecoration(
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
              labelText: 'Kullanıcı Adı',
              prefixIcon: Icon(Icons.person, color: scheme.primary),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: regEmailController,
            decoration: InputDecoration(
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
              labelText: 'E-mail',
              prefixIcon: Icon(FontAwesomeIcons.at, color: scheme.primary),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            obscureText: isObscure,
            controller: regPasswordController,
            decoration: InputDecoration(
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
              labelText: 'Şifre ',
              prefixIcon: Icon(Icons.lock, color: scheme.primary),
              suffixIcon: IconButton(
                onPressed: () => setState(() => isObscure = !isObscure),
                icon: Icon(
                  isObscure ? Icons.visibility_off : Icons.visibility,
                  color: scheme.onPrimary,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: authProvider.isLoading
                ? null
                : () async {
                    final email = regEmailController.text.trim();
                    final password = regPasswordController.text.trim();
                    final username = userNameController.text.trim();

                    if (email.isEmpty || password.isEmpty || username.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Lütfen tüm alanları doldurun'),
                        ),
                      );
                      return;
                    }
                    final result = await context
                        .read<UserAuthProvider>()
                        .signUp(
                          email: email,
                          password: password,
                          username: username,
                        );

                    if (result.isSuccess) {
                      if (!mounted) return;

                      try {
                        await context.read<UserAuthProvider>().initialize();
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Kullanıcı verileri yüklenemedi: $e",
                              ),
                            ),
                          );
                        }
                        return; 
                      }

                      if (mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ),
                        );
                      }
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              result.errorMessage ?? 'Kayıt başarısız',
                            ),
                          ),
                        );
                      }
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: scheme.primary,
              foregroundColor: scheme.surface,
              minimumSize: Size(double.infinity, 50),
            ),
            child: authProvider.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Kayıt Ol', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
