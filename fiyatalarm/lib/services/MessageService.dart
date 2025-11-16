import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addMessage({
    required String title,
    required String content,
    required DateTime sendAt,
  }) async {
    try {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection("messages").add({
      "userId": user.uid,
      "title": title.trim(),
      "content": content.trim(),
      "sendAt": Timestamp.fromDate(sendAt),
      "createdAt": Timestamp.now(),
      "delivered": false,
    });
     print("Mesaj başarıyla kaydedildi.");
     } catch (e) {
      print("Mesaj ekleme hatası: $e");
      rethrow;
    }
  }
    Stream<QuerySnapshot> getUpcomingMessages() {
    final user = _auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection("messages")
        .where("userId", isEqualTo: user.uid)
        .where("delivered", isEqualTo: false)
        .orderBy("sendAt")
        .snapshots();
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      await _firestore.collection("messages").doc(messageId).delete();
      print("Mesaj silindi: $messageId");
    } catch (e) {
      print("Mesaj silme hatası: $e");
      rethrow;
    }
  }

  Future<void> updateMessage(
    String messageId, {
    required String title,
    required String content,
    required DateTime sendAt,
  }) async {
    try {
      await _firestore.collection("messages").doc(messageId).update({
        "title": title.trim(),
        "content": content.trim(),
        "sendAt": Timestamp.fromDate(sendAt),
      });
      print("Mesaj güncellendi: $messageId");
    } catch (e) {
      print("Mesaj güncelleme hatası: $e");
      rethrow;
    }
  }
}