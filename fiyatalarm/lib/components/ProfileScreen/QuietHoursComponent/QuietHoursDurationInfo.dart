import 'package:flutter/material.dart';

class QuietHoursDurationInfo extends StatelessWidget {
  final String warningText;
  final String durationText;

  const QuietHoursDurationInfo({
    super.key,
    required this.durationText,
    required this.warningText,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                warningText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.error.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                durationText,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
