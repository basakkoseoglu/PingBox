import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fiyatalarm/Models/QuietHours.dart';
import 'package:fiyatalarm/Models/UserModel.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUser(String username) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final fcmToken = await FirebaseMessaging.instance.getToken();

    final userData = {
      'email': user.email,
      'username': username,
      'fcmToken': fcmToken,
      'updatedAt': DateTime.now(),
    };

    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(userData, SetOptions(merge: true));

    print("Kullanıcı verisi kaydedildi: $userData");
  }

  Future<void> updateFcmToken() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken == null) return;

    await _firestore.collection('users').doc(user.uid).set({
      'fcmToken': fcmToken,
      'updatedAt': DateTime.now(),
    }, SetOptions(merge: true));
  }

  Future<UserModel?> loadUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    return UserModel.fromMap(doc.data()!, user.uid);
  }

  Future<void> updateAvatar(String avatarPath) async {
  final user = _auth.currentUser;
  if (user == null) return;

  await _firestore.collection('users').doc(user.uid).set({
    'avatarPath': avatarPath,
    'updatedAt': DateTime.now(),
  }, SetOptions(merge: true));

  print("Avatar güncellendi: $avatarPath");
}

// Sessiz saatleri güncelle
Future<void> updateQuietHours(QuietHours quietHours) async {
  final user = _auth.currentUser;
  if (user == null) return;

  await _firestore.collection('users').doc(user.uid).set({
    'quietHours': quietHours.toMap(),
    'updatedAt': DateTime.now(),
  }, SetOptions(merge: true));

  print("Sessiz saatler güncellendi: ${quietHours.getDisplayText()}");
}
}
