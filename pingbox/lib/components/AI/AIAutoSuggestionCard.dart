import 'package:flutter/material.dart';

class AIAutoSuggestionCard extends StatelessWidget {
  final String title;
  final String desc;
  final String mode;

  const AIAutoSuggestionCard({
    super.key,
    required this.title,
    required this.desc,
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
    final color = _resolveModeColor(scheme);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.6), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.12),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            desc.replaceAll("*", ""),
            style: TextStyle(
              fontSize: 15,
              height: 1.3,
              color: scheme.onSurface.withOpacity(0.85),
            ),
          ),
          
        ],
      ),
    );
  }
}
