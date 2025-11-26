import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScheduledCoachRemindersService {
  final _firestore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  Future<Map<String, dynamic>?> getTodayScheduled() async {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day, 0, 0, 0);
    final end = DateTime(today.year, today.month, today.day, 23, 59, 59);

    final snap = await _firestore
        .collection("scheduledCoachReminders")
        .where("userId", isEqualTo: uid)
        .where("runAt", isGreaterThanOrEqualTo: start)
        .where("runAt", isLessThanOrEqualTo: end)
        .orderBy("runAt", descending: false)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;

    return snap.docs.first.data();
  }
}
