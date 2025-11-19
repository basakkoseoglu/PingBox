import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //kayıt ol
  Future<User?> signUp(String email, String password, String username) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "username": username,
        "email": email,
        "createdAt": DateTime.now(),
      }, SetOptions(merge: true));

      return userCredential.user;
    } catch (e) {
      print("Kayıt Hatası: $e");
      return null;
    }
  }

  //giriş yap
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
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
