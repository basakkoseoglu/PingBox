import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //kayıt ol
  Future<User?>signUp(String email,String password) async{
    try{
      UserCredential userCredential=await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    }catch(e){
      print("Kayıt Hatası: $e");
      return null;
    }
  }

  //giriş yap
  Future<User?> signIn(String email,String password) async {
    try {
      UserCredential userCredential  = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print("Giriş Hatası: $e");
      return null;
    }
  }

  //çıkış yap
  Future<void> signOut() async {
    await _auth.signOut();
  }

}