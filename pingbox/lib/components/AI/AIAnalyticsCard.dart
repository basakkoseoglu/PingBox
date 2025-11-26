import 'package:flutter/material.dart';

class AIAnalyticsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final String mode;


  const AIAnalyticsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
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
      width: 120,
      padding: const EdgeInsets.all(18),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Icon(
            icon,
            size: 28,
            color: modeColor,
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: scheme.onSurface.withOpacity(0.7),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
