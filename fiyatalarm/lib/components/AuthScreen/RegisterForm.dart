import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
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
              labelText: 'Kullanıcı Adı',
              prefixIcon: Icon(Icons.person),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: regEmailController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              labelText: 'E-mail',
              prefixIcon: Icon(Icons.email),
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
              labelText: 'Şifre ',
              prefixIcon: Icon(Icons.lock),
              suffixIcon: IconButton(
                onPressed: () => setState(() => isObscure = !isObscure),
                icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              authService.signUp(
                regEmailController.text.trim(),
                regPasswordController.text.trim(),
              );
              print("Kayıt Olundu");
            },
            child: const Text(
              'Kayıt Ol',
              style: TextStyle(fontSize: 18, color: Colors.white),
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
