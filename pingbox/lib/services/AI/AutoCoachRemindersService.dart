import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AutoCoachRemindersService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<String?> getTodayReminder() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(const Duration(days: 1));

    final autoSnap = await _db
        .collection("autoCoachReminders")
        .where("userId", isEqualTo: user.uid)
        .where("createdAt", isGreaterThanOrEqualTo: start)
        .where("createdAt", isLessThan: end)
        .orderBy("createdAt", descending: true)
        .limit(1)
        .get();

    if (autoSnap.docs.isNotEmpty) {
      return autoSnap.docs.first["reminder"];
    }

    final scheduledSnap = await _db
        .collection("scheduledCoachReminders")
        .where("userId", isEqualTo: user.uid)
        .where("runAt", isGreaterThanOrEqualTo: start)
        .where("runAt", isLessThan: end)
        .orderBy("runAt", descending: true)
        .limit(1)
        .get();

    if (scheduledSnap.docs.isNotEmpty) {
      return scheduledSnap.docs.first["reminder"];
    }

    return null;
  }
}
