import 'package:flutter/material.dart';

class EmptyMessage extends StatelessWidget {
  final String message;
  final IconData? icon;
  const EmptyMessage({super.key,
    this.message = "Henüz arşivlenmiş mesajın yok.",
    this.icon,});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 80,
              color: colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}