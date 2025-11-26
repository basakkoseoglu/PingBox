import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
        "avatarPath": "assets/avatars/avatar_default.png",
        "createdAt": DateTime.now(),
      }, SetOptions(merge: true));

      return userCredential.user;
    } catch (e) {
      print("Kayıt Hatası: $e");
      return null;
    }
  }

//google ile giriş
  Future<User?> signInWithGoogle() async{
    try{

      await GoogleSignIn.instance.initialize();
      final GoogleSignInAccount? googleUser=await GoogleSignIn.instance.authenticate();
      if(googleUser== null){
        throw Exception("Google oturum açma işlemi kullanıcı tarafından iptal edildi");
      }
      final GoogleSignInAuthentication googleAuth=await googleUser.authentication;
      final credential=GoogleAuthProvider.credential(
        idToken: googleAuth.idToken
      );
      final userCred=await _auth.signInWithCredential(credential);

      final user=userCred.user;
      return user;
    }on FirebaseAuthException catch(error){
      throw Exception(error.message);
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
    await GoogleSignIn.instance.signOut();
  }
}
