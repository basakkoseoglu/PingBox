import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //mesaj ekleme
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

  //planlananan mesajları getirme
  Stream<QuerySnapshot> getUpcomingMessages() {
    //sürekli canlı takip etmek için streeam kullanıldı
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

  //mesaj silme fonk
  Future<void> deleteMessage(String messageId) async {
    try {
      await _firestore.collection("messages").doc(messageId).delete();
      print("Mesaj silindi: $messageId");
    } catch (e) {
      print("Mesaj silme hatası: $e");
      rethrow;
    }
  }

  //mesaj güncelleme fonk
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

  //gelen mesajlar fonk
  Stream<QuerySnapshot> getArchiveMessages() {
    final user = _auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection("messages")
        .where("userId", isEqualTo: user.uid)
        .where("delivered", isEqualTo: true)
        .orderBy("sendAt", descending: true)
        .snapshots();
  }

  //mesajı teslim edildi olarak işaretleme fonk
  Future<void> markAsDelivered(String messageId) async {
    await _firestore.collection('messages').doc(messageId).update({
      'delivered': true,
      'openedAt': DateTime.now(),
    });
  }

  //tekrar gönder
  Future<void> resendMessage({
    required String content,
    required String title,
    required DateTime newSendAt,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('messages').add({
      "userId": user.uid,
      "title": title,
      "content": content,
      "sendAt": newSendAt,
      "createdAt": DateTime.now(),
      "delivered": false,
    });
  }

  //favorilere ekleme
  Future<void> saveMessage(String messageId, Map<String, dynamic> data) async {
  final user = _auth.currentUser;
  if (user == null) return;

  await _firestore.collection('savedMessages').add({
    "userId": user.uid,
    "title": data["title"],
    "content": data["content"],
    "originalMessageId": messageId,
    "savedAt": DateTime.now(),
  });
}

}
