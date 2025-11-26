import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AutoSuggestionsService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> getTodaySuggestions() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(const Duration(days: 1));

    final snap = await _firestore
        .collection("autoSuggestions")
        .where("userId", isEqualTo: user.uid)
        .where("createdAt", isGreaterThanOrEqualTo: start)
        .where("createdAt", isLessThan: end)
        .orderBy("createdAt", descending: true)
        .get();

    return snap.docs.map((d) => d.data()).toList();
  }
}
