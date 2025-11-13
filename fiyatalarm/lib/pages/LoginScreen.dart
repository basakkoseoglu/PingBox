import 'package:flutter/material.dart';

import 'RegisterScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50,bottom: 20),
                child: Image.asset(
                  'assets/logo/alarmlogo.png',
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20,),
              Text("Giriş Yap",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    SizedBox(height: 20,),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: 'Şifre',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: Icon(Icons.visibility_off),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: () {
                      },
                      child: Text('Giriş Yap',style: TextStyle(fontSize: 18,color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50), 
                        backgroundColor: Colors.blue
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>RegisterScreen(),));
                    }, child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Hesabınız yok mu? ",
                              style: TextStyle(color: Colors.black54),
                            ),
                            TextSpan(
                              text: "Kayıt Ol",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),)
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
