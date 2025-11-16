import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

   Future<void> saveDeviceToken(String uid) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      print("Device Token: $token");

      if (token != null) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .set({
          "deviceToken": token,
          "updatedAt": DateTime.now(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print("Token Kayıt Hatası: $e");
    }
  }

  //kayıt ol
  Future<User?>signUp(String email,String password) async{
    try{
      UserCredential userCredential=await _auth.createUserWithEmailAndPassword(email: email, password: password);
       await saveDeviceToken(userCredential.user!.uid);
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
       await saveDeviceToken(userCredential.user!.uid);
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