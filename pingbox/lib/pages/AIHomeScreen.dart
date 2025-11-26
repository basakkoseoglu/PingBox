import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pingbox/components/AI/AIAnalyticsRow.dart';
import 'package:pingbox/components/AI/AIAutoSuggestionCard.dart';
import 'package:pingbox/components/AI/AIHomeHeader.dart';
import 'package:pingbox/components/AI/CoachModeCard.dart';
import 'package:pingbox/components/AI/Shimmers/AIHomeShimmer.dart';
import 'package:pingbox/components/AI/TodayReminderCard.dart';
import 'package:pingbox/components/AI/TodayScheduledCard.dart';
import 'package:pingbox/providers/UserAuthProvider.dart';
import 'package:pingbox/services/AI/AutoCoachRemindersService.dart';
import 'package:pingbox/services/AI/AutoSuggestionsService.dart';
import 'package:pingbox/services/AI/CoachModesService.dart';
import 'package:pingbox/services/AI/ScheduledCoachRemindersService.dart';
import 'package:pingbox/services/AI/UserPatternsService.dart';
import 'package:provider/provider.dart';

class AIHomeScreen extends StatefulWidget {
  const AIHomeScreen({super.key});

  @override
  State<AIHomeScreen> createState() => _AIHomeScreenState();
}

class _AIHomeScreenState extends State<AIHomeScreen> {
  bool isLoading = true;


  String activeHour = "-";
  String topCategory = "-";
  String mood = "-";

  String coachMode = "-";
  String coachReason = "-";

  String todayReminderText = "";

  String todayScheduledReminder = "";
  String todayScheduledTime = "";

  List<Map<String, String>> suggestions = [];

  String formatHour(dynamic raw) {
    if (raw == null) return "-";

    try {
      final hour = int.parse(raw.toString());
      return "${hour.toString().padLeft(2, '0')}:00";
    } catch (_) {
      return raw.toString();
    }
  }

  String formatCategory(String raw) {
    if (raw.isEmpty) return "-";

    final map = {
      "water": "Su",
      "health": "Sağlık",
      "project": "Proje",
      "shopping": "Alışveriş",
      "family": "Aile",
      "reminder": "Hatırlatma",
      "focus": "Odak",
      "note": "Not",
      "exercise": "Spor",
      "food": "Beslenme",
      "planning": "Plan",
    };

    final lower = raw.toLowerCase();
    return map[lower] ?? lower.capitalize();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) { 
        loadBackendData();
      }
  });
  }

  Future<void> loadBackendData() async {
    final userPatternsService = UserPatternsService();
    final coachModesService = CoachModesService();
    final suggestionsService = AutoSuggestionsService();

    //userpatterns
    final patterns = await userPatternsService.getUserPatterns();
     if (patterns != null && mounted) {
      setState(() {
        activeHour = formatHour(patterns["mostActiveHour"]);
        topCategory = formatCategory(patterns["mostUsedCategory"] ?? "-");

        final moodAvg = patterns["moodAverage"] ?? 0;
        mood = moodAvg >= 0.3
            ? "Pozitif"
            : moodAvg <= -0.3
            ? "Negatif"
            : "Nötr";
      });
    }

    //coachmode
    final modeData = await coachModesService.getTodayCoachMode();
    if (modeData != null && mounted) {
      setState(() {
        coachMode = (modeData["mode"] ?? "focus").toString().toUpperCase();
        coachReason = modeData["reason"] ?? "";
      });
    }

    final backendSuggestions = await suggestionsService.getTodaySuggestions();
      if (mounted){
    setState(() {
      for (final s in backendSuggestions) {
        suggestions.add({
          "title": s["title"] ?? "AI Önerisi",
          "desc": s["content"] ?? "",
        });
      }
      isLoading = false;
    });
      }

    final remindersService = AutoCoachRemindersService();
    final todayReminder = await remindersService.getTodayReminder();

    if (todayReminder != null && mounted) {
      setState(() {
        todayReminderText = todayReminder;
      });
    }

    final scheduledService = ScheduledCoachRemindersService();
    final scheduledData = await scheduledService.getTodayScheduled();

    if (scheduledData != null && mounted) {
      final dt = (scheduledData["runAt"] as Timestamp).toDate();
      final formattedTime =
          "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";

      setState(() {
        todayScheduledReminder = scheduledData["reminder"] ?? "";
        todayScheduledTime = formattedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final authProvider = Provider.of<UserAuthProvider>(context);

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
         child: isLoading
        ? const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: AIHomeShimmer(),
          )
        : SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AIHomeHeader(
                username: authProvider.username,
                avatarUrl: authProvider.avatarPath,
              ),
              const SizedBox(height: 24),
              CoachModeCard(mode: coachMode, reason: coachReason),

              const SizedBox(height: 24),
              if (todayReminderText.isNotEmpty)
                TodayReminderCard(
                  reminderText: todayReminderText,
                  mode: coachMode,
                ),

              const SizedBox(height: 24),
              if (todayScheduledReminder.isNotEmpty)
                TodayScheduledCard(
                  reminderText: todayScheduledReminder,
                  time: todayScheduledTime,
                  mode: coachMode,
                ),

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

              AIAnalyticsRow(
                activeHour: activeHour,
                topCategory: topCategory,
                mood: mood,
              ),

              const SizedBox(height: 24),

              Text(
                "Bugünün AI Önerileri",
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
                        child: AIAutoSuggestionCard(
                          title: s['title']?.toString() ?? "AI Önerisi",
                          desc:
                              s['desc']?.toString() ??
                              "Bugün için öneri bulunamadı.",
                          mode: coachMode,
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

extension CapExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
