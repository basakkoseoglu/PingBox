import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserDeviceToken() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final fcmToken = await FirebaseMessaging.instance.getToken();

    if (fcmToken == null) {
      print("FCM token alınamadı.");
      return;
    }
    await _firestore.collection('users').doc(user.uid).set({
      'email': user.email,
      'fcmToken': fcmToken,
      'updatedAt': DateTime.now(),
    }, SetOptions(merge: true));

    print("✅ FCM token kaydedildi: $fcmToken");
  }
}
