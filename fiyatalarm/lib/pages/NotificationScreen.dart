import 'package:flutter/material.dart';

import '../Modals/MessageDetail.dart';

class NotificationScreen extends StatelessWidget {
  final List<Map<String, dynamic>> messages = [
    {
      "title": "Merhaba gelecekteki ben nasılsın",
      "content": "Bugün çok yorgundun ama güçlüsün...",
      "date": DateTime(2025, 12, 2, 22, 0),
    },
    {
      "title": "Unutma güçlüsün",
      "content": "Bu mesajı moral için göndermiştin.",
      "date": DateTime(2025, 11, 12, 18, 30),
    },
  ];

  NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Bildirimler',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Gelen mesajlarınız',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => MessageDetailModal(message: message),
                        );
                      },
                      child: _messageCard(
                        context: context,
                        title: message["title"],
                        content: message["content"],
                        date: message["date"],
                        index: index,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _messageCard({
    required BuildContext context,
    required String title,
    required String content,
    required DateTime date,
    required int index,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    final cardColors = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
    ];
    final accentColor = cardColors[index % cardColors.length];

    return Container(
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
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
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
                      "${date.day}/${date.month}/${date.year} - ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}",
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
