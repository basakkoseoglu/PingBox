import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AIService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // kullanıcı rutinleri koleksiyonu
  Future<void> createUserPatternIfNotExists() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _firestore.collection("userPatterns").doc(user.uid);
    final doc = await docRef.get();

    if (doc.exists) {
      return;
    }

    await docRef.set({
      "userId": user.uid,
      "prefferredHours": [9, 21],
      "frequentTopics": [],
      "weeklyStats": {
        "monday": 0,
        "tuesday": 0,
        "wednesday": 0,
        "thursday": 0,
        "friday": 0,
        "saturday": 0,
        "sunday": 0,
      },
      "lastAnalysis": null,
    });
  }

  //AI öneri hatırlatmaları
  Future<void> addAISuggestion({
    required String title,
    required String content,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection("autoSuggestions").add({
        "userId": user.uid,
        "title": title.trim(),
        "content": content.trim(),
        "createdAt": Timestamp.now(),
        "sent": false,
      });
    } catch (e) {
      print("AI önerisi ekleme hatası: $e");
    }
  }



 //haftalık kullanım davranışı
  Future<void> updatePatternStatsOnMessageCreated() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _firestore.collection("userPatterns").doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      await createUserPatternIfNotExists();
    }

    final now = DateTime.now();
    final weekday = now.weekday;

    final dayKeys = {
      1: "monday",
      2: "tuesday",
      3: "wednesday",
      4: "thursday",
      5: "friday",
      6: "saturday",
      7: "sunday",
    };

    final todayKey = dayKeys[weekday];

    if (todayKey == null) return;

    // mevcut weeklyStats verisi
    final data = doc.data() as Map<String, dynamic>;
    final weeklyStats = Map<String, dynamic>.from(data["weeklyStats"]);

    // bugünün değerini +1 yap
    weeklyStats[todayKey] = (weeklyStats[todayKey] ?? 0) + 1;

    // güncellenmiş weeklyStatsı firestore a ekle
    await docRef.update({
      "weeklyStats": weeklyStats,
      "lastAnalysis": Timestamp.now(),
    });
  }


  //aktif saat aralığı
  Future<void> updatePreferredHoursOnActivity() async {
  final user = _auth.currentUser;
  if (user == null) return;

  final docRef = _firestore.collection("userPatterns").doc(user.uid);
  final doc = await docRef.get();

  if (!doc.exists) {
    await createUserPatternIfNotExists();
  }

  
  final now = DateTime.now();
  final currentHour = now.hour; //şuanki saat 23.17se 23ü alır

  final data = doc.data() as Map<String, dynamic>;
  final preferredHours = List<int>.from(data["preferredHours"]);

  int start = preferredHours[0];
  int end = preferredHours[1];

  // mebcut saatin dışındaysa mevcut saati ona göre düzelt
  if (currentHour < start) {
    start = currentHour;
  } else if (currentHour > end) {
    end = currentHour;
  }

  await docRef.update({
    "preferredHours": [start, end],
    "lastAnalysis": Timestamp.now(),
  });
}

//mesaj içeriğinden anahtar kelime çıkarma
Future<void> updateFrequentTopicsOnMessage(String text) async {
  final user = _auth.currentUser;
  if (user == null) return;

  final docRef = _firestore.collection("userPatterns").doc(user.uid);
  final doc = await docRef.get();

  if (!doc.exists) {
    await createUserPatternIfNotExists();
  }

  // Mesinden anahtar kelimeleri çıkar
  final extracted = _extractKeywords(text);

  final data = doc.data() as Map<String, dynamic>;
  final topics = List<String>.from(data["frequentTopics"]);

  for (final word in extracted) {
    if (!topics.contains(word)) {
      topics.add(word);
    }
  }

  await docRef.update({
    "frequentTopics": topics,
    "lastAnalysis": Timestamp.now(),
  });
}


List<String> _extractKeywords(String text) {
  final lower = text.toLowerCase();

  final words = lower
      .replaceAll(RegExp(r"[^a-zA-Z0-9ğüşöçıİĞÜŞÖÇ ]"), "")
      .split(" ")
      .where((w) => w.trim().isNotEmpty)
      .toList();

  final keywords = words.where((w) => w.length > 2).toList();

  return keywords;
}


Future<void> analyzeUserPatternsOnMessage(String text) async {
  // 1. haftalık kullanım artışı
  await updatePatternStatsOnMessageCreated();

  // 2. saat aralığı
  await updatePreferredHoursOnActivity();

  // 3. konu analizi
  await updateFrequentTopicsOnMessage(text);
}



}
