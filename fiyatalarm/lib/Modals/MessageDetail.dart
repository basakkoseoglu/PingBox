import 'package:flutter/material.dart';

class MessageDetailModal extends StatelessWidget {
  final Map message;

  const MessageDetailModal({super.key, required this.message});

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}"
        ".${date.month.toString().padLeft(2, '0')}"
        ".${date.year} - ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final DateTime msgDate = message["date"];
    final String formattedDate = formatDate(msgDate);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.mail_rounded,
                      color: colorScheme.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message["title"],
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formattedDate,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 13,
                            color: colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Container(
                height: 1,
                color: colorScheme.onSurface.withOpacity(0.1),
              ),

              const SizedBox(height: 20),

              Text(
                message["content"],
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 15,
                  height: 1.6,
                  color: colorScheme.onSurface.withOpacity(0.8),
                ),
              ),

              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: _actionButton(
                      context: context,
                      label: "Sakla",
                      icon: Icons.bookmark_outline,
                      color: colorScheme.primary,
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _actionButton(
                      context: context,
                      label: "Sil",
                      icon: Icons.delete_outline,
                      color: colorScheme.error,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              _actionButton(
                context: context,
                label: "Tekrar Gönder",
                icon: Icons.send_rounded,
                color: colorScheme.secondary,
                onTap: () {},
                fullWidth: true,
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool fullWidth = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}