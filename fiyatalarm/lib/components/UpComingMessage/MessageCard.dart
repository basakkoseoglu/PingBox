import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiyatalarm/Modals/EditMessage.dart';
import 'package:fiyatalarm/components/Diaologs/CustomConfirmDialog.dart';
import 'package:fiyatalarm/components/UpComingMessage/ActionButton.dart';
import 'package:fiyatalarm/providers/MessageProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageCard extends StatelessWidget {
  final String title;
  final String content;
  final int index;
  final String messageId;

  const MessageCard({
    super.key,
    required this.title,
    required this.content,
    required this.index,
    required this.messageId,
  });

  @override
  Widget build(BuildContext context) {
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
        child: Stack(
          children: [
            Padding(
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
                    child: Icon(
                      Icons.schedule_rounded,
                      color: accentColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
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
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontSize: 13,
                                height: 1.4,
                                color: colorScheme.onSurface.withOpacity(0.65),
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      ActionButton(
                        color: colorScheme.inversePrimary,
                        icon: Icons.edit,
                        onTap: () async {
                          final doc = await FirebaseFirestore.instance
                              .collection("messages")
                              .doc(messageId)
                              .get();

                          final result = await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => EditMessageModal(doc: doc),
                          );

                          if (result == true && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Mesaj güncellendi"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        },
                      ),
                      ActionButton(
                        icon: Icons.delete,
                        color: colorScheme.error,
                        onTap: () async {
                          final confirm = await AppDialogs.show(
                            context,
                            title: 'Mesajı Sil',
                            message:
                                'Bu mesajı silmek istediğinize emin misiniz?',
                            primaryButton: 'Sil',
                            secondaryButton: 'Vazgeç',
                            primaryColor: Colors.red,
                          );

                          if (confirm == true && context.mounted) {
                            final success = await context
                                .read<MessageProvider>()
                                .deleteMessage(messageId);
                            if (success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Mesaj silindi"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Silme hatası"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
