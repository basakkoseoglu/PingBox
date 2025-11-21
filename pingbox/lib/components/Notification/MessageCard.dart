import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageCard extends StatelessWidget {
  final String messageId;
  final String title;
  final String content;
  final DateTime date;
  final int index;
  final VoidCallback onTap;

  const MessageCard({
    super.key,
    required this.messageId,
    required this.title,
    required this.content,
    required this.date,
    required this.index,
    required this.onTap,});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cardColors = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
    ];
    final accentColor = cardColors[index % cardColors.length];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accentColor.withOpacity(0.2), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.mail_outline, color: accentColor, size: 22),
              ),
      
              const SizedBox(width: 14),
      
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: colorScheme.onSurface,
                      ),
                    ),
      
                    const SizedBox(height: 6),
      
                    Text(
                      content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 13,
                        height: 1.4,
                        color: colorScheme.onSurface.withOpacity(0.65),
                      ),
                    ),
      
                    const SizedBox(height: 8),
      
                    Text(
                      DateFormat("dd.MM.yyyy - HH:mm").format(date),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
      
              const SizedBox(width: 8),
      
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurface.withOpacity(0.3),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}