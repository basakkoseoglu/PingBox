import 'package:fiyatalarm/pages/MainScreen.dart';
import 'package:fiyatalarm/services/UserService.dart';
import 'package:fiyatalarm/theme/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../services/AuthService.dart';

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

  final AuthService authService = AuthService();
  final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
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
               borderSide: BorderSide( color: Theme.of(context).brightness == Brightness.light
            ? AppColors.borderLight
            : AppColors.borderDark,),
              borderRadius: BorderRadius.circular(12),
            ),
              labelText: 'Kullanıcı Adı',
              prefixIcon: Icon(Icons.person,color: scheme.primary),
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
              borderSide: BorderSide( color: Theme.of(context).brightness == Brightness.light
            ? AppColors.borderLight
            : AppColors.borderDark,),
              borderRadius: BorderRadius.circular(12),
            ),
              labelText: 'E-mail',
              prefixIcon: Icon(FontAwesomeIcons.at,color: scheme.primary),
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
               borderSide: BorderSide( color: Theme.of(context).brightness == Brightness.light
            ? AppColors.borderLight
            : AppColors.borderDark,),
              borderRadius: BorderRadius.circular(12),
            ),
              labelText: 'Şifre ',
              prefixIcon: Icon(Icons.lock,color: scheme.primary),
              suffixIcon: IconButton(
                onPressed: () => setState(() => isObscure = !isObscure),
                icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility, color: scheme.onPrimary,),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async{
             final user= authService.signUp(
                regEmailController.text.trim(),
                regPasswordController.text.trim(),
              );
              if (user != null) {
                await userService.saveUserDeviceToken();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                );
              }
              print("Kayıt Olundu");
            },
            child: const Text(
              'Kayıt Ol',
              style: TextStyle(fontSize: 18),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: scheme.primary,
              foregroundColor: scheme.surface,
              minimumSize: Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }
}
