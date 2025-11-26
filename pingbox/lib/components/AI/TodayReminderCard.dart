import 'package:flutter/material.dart';

class TodayReminderCard extends StatelessWidget {
  final String reminderText;
  final String mode;

  const TodayReminderCard({
    super.key,
    required this.reminderText,
    required this.mode,
  });

  Color _resolveModeColor(ColorScheme scheme) {
    switch (mode.toLowerCase()) {
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: modeColor.withOpacity(0.8), width: 1),
        boxShadow: [
          BoxShadow(
            color: modeColor.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bugünün Hatırlatması",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: scheme.onSurface.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  reminderText.replaceAll("*", ""),
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.35,
                    color: scheme.onSurface.withOpacity(0.75),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
