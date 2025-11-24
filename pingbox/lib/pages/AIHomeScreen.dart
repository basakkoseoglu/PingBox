import 'package:flutter/material.dart';
import 'package:pingbox/providers/UserAuthProvider.dart';
import 'package:pingbox/services/GeminiService.dart';
import 'package:pingbox/services/MessageAnalysisService.dart';
import 'package:provider/provider.dart';

class AIHomeScreen extends StatefulWidget {
  const AIHomeScreen({super.key});

  @override
  State<AIHomeScreen> createState() => _AIHomeScreenState();
}

class _AIHomeScreenState extends State<AIHomeScreen> {
  List<Map<String, String>> suggestions = [];
  bool isLoading = false;

  Future<void> generateTodayAdvice() async {
    setState(() => isLoading = true);

    final gemini = GeminiService(
      apiKey: "<your_api_key>",
    );

    final advice = await gemini.generateAdvice();

    setState(() {
      suggestions.insert(0, {"title": "AI Önerisi", "desc": advice});
      isLoading = false;
    });
  }
  Future<void> analyzeUserMessages() async {
  setState(() => isLoading = true);

  final messageService = MessageAnalysisService();
  final gemini = GeminiService(apiKey: "your_api_key");

  final messages = await messageService.getUserMessages();

  final analysis = await gemini.analyzeMessages(messages);

  setState(() {
    suggestions.insert(0, {
      "title": "Mesaj Analizi Sonucu",
      "desc": """
Ruh hali: ${analysis["ruh_hali"]}
Kategori: ${analysis["en_sik_kategori"]}
Aktif saat: ${analysis["aktif_saat"]}

Yorum: ${analysis["yorum"]}
"""
    });

    isLoading = false;
  });
}


  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final authProvider = Provider.of<UserAuthProvider>(context);

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Merhaba ${authProvider.username} 👋",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Bugünkü AI Koçun hazır.",
                style: TextStyle(
                  fontSize: 16,
                  color: scheme.onSurface.withOpacity(0.7),
                ),
              ),

              const SizedBox(height: 24),
              _buildTodayModeCard(context),
              const SizedBox(height: 24),

              Text(
                "AI Analizleri",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),

              _buildAnalyticsHorizontalScroll(context),

              const SizedBox(height: 24),

              Text(
                "Otomatik Öneriler",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),

              Column(
                children: suggestions
                    .map(
                      (s) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildSuggestionCard(
                          context,
                          title: s['title']!,
                          desc: s['desc']!,
                        ),
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 16),

              FilledButton(
                onPressed: isLoading ? null : generateTodayAdvice,

                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Bugün için öneri üret",
                        style: TextStyle(fontSize: 18),
                      ),
              ),

              const SizedBox(height: 12),

              OutlinedButton(
                onPressed: isLoading ? null : analyzeUserMessages,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 54),
                  side: BorderSide(color: scheme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Mesajlarını analiz et",
                  style: TextStyle(fontSize: 18),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodayModeCard(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primary.withOpacity(0.8),
            scheme.primary.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bugünkü Modun",
            style: TextStyle(
              color: scheme.onPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Focus",
            style: TextStyle(
              color: scheme.onPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Zihnin bugün net. Bu modu kullanmak için 30 dakikalık bir hedef belirleyebilirsin.",
            style: TextStyle(
              color: scheme.onPrimary.withOpacity(0.9),
              fontSize: 15,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsHorizontalScroll(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildMiniCard(
            context,
            title: "En aktif saat",
            value: "22:00",
            icon: Icons.access_time,
          ),
          const SizedBox(width: 12),
          _buildMiniCard(
            context,
            title: "Kategori",
            value: "Hatırlatma",
            icon: Icons.category,
          ),
          const SizedBox(width: 12),
          _buildMiniCard(
            context,
            title: "Ruh hali",
            value: "Pozitif",
            icon: Icons.favorite,
          ),
        ],
      ),
    );
  }

  Widget _buildMiniCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 26, color: scheme.primary),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              color: scheme.onSurface.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: scheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(
    BuildContext context, {
    required String title,
    required String desc,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: scheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            desc
                .replaceAll('*', '')
                .replaceAll('_', '')
                .replaceAll('#', '')
                .replaceAll('•', ''),

            style: TextStyle(
              color: scheme.onSurface.withOpacity(0.7),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
