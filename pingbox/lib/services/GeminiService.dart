import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String apiKey;

  GeminiService({required this.apiKey});

  Future<String> generateAdvice() async {
    final model = GenerativeModel(model: 'gemini-2.5-flash-preview-09-2025', apiKey: apiKey);
    final prompt = """
Kullanıcı için günlük kısa bir kişisel gelişim önerisi üret.
Ton: motive edici, kısa, uygulanabilir.
Seni yormayacak, küçük ama etkili bir öneri olsun.
Emoji kullanabilirsin ama çok abartma. 
""";

    final response = await model.generateContent([Content.text(prompt)]);

    return response.text ??
        "Bugün için güzel bir önerim yok, ama moralini yüksek tut 😊";
  }


  Future<Map<String, dynamic>> analyzeMessages(List<Map<String, dynamic>> messages) async {
  final model = GenerativeModel(
    model: 'gemini-2.5-flash-preview-09-2025',
    apiKey: apiKey,
  );

  final textData = messages.map((m) {
    return "- ${m["title"]}: ${m["content"]}";
  }).join("\n");

  final prompt = """
Aşağıdaki kullanıcı mesajlarını analiz et:

$textData

Bu mesajlara göre aşağıdaki JSON formatında cevap üret:

{
  "ruh_hali": "...",
  "en_sik_kategori": "...",
  "aktif_saat": "...",
  "yorum": "..."
}

Sadece JSON ver.
""";

  final response = await model.generateContent([
    Content.text(prompt),
  ]);

  final text = response.text ?? '{}';

  try {
    return Map<String, dynamic>.from(jsonDecode(text));
  } catch (e) {
    return {
      "ruh_hali": "Bilinmiyor",
      "en_sik_kategori": "Bilinmiyor",
      "aktif_saat": "Bilinmiyor",
      "yorum": "Analiz yapılamadı."
    };
  }
}

  
}
