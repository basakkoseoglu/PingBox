import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageAnalysisService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> getUserMessages() async {
    final user = auth.currentUser;
    if (user == null) return [];

    final query = await firestore
        .collection("messages")
        .where("userId", isEqualTo: user.uid)
        .orderBy("createdAt", descending: true)
        .limit(30) 
        .get();

    return query.docs.map((doc) => doc.data()).toList();
  }
}
