import 'package:flutter/material.dart';

class TodayScheduledCard extends StatelessWidget {
  final String reminderText;
  final String time;
  final String? mode;

  const TodayScheduledCard({
    super.key,
    required this.reminderText,
    required this.time,
    this.mode,
  });

  Color _resolveModeColor(ColorScheme scheme) {
    final m = mode?.toLowerCase() ?? "";

    switch (m) {
      case "focus":
        return scheme.primary;
      case "relax":
        return Colors.lightBlueAccent;
      case "energy_boost":
        return Colors.amber;
      case "mood_support":
        return Colors.pinkAccent;
      case "health":
        return scheme.tertiary;
      default:
        return scheme.primary.withOpacity(0.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final modeColor = _resolveModeColor(scheme);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: modeColor.withOpacity(0.6), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: modeColor.withOpacity(0.12),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.notifications_active_rounded,
                color: modeColor,
                size: 28,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Planlı Hatırlatma ($time)",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            reminderText,
            style: TextStyle(
              fontSize: 16,
              height: 1.35,
              fontWeight: FontWeight.w400,
              color: scheme.onSurface.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }
}
