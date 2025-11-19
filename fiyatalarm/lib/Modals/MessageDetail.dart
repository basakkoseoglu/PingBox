import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiyatalarm/components/Diaologs/CustomConfirmDialog.dart';
import 'package:fiyatalarm/services/MessageService.dart';
import 'package:flutter/material.dart';


class MessageDetailModal extends StatelessWidget {
  final DocumentSnapshot doc;

  const MessageDetailModal({super.key, required this.doc});

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}"
        ".${date.month.toString().padLeft(2, '0')}"
        ".${date.year} - ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  String timeAgo(DateTime createdAt) {
    final now = DateTime.now();
    final diff = now.difference(createdAt).inDays;

    if (diff == 0) return "Bugün yazmıştın.";
    if (diff == 1) return "Bu mesajı 1 gün önce yazmıştın.";
    return "Bu mesajı $diff gün önce yazmıştın.";
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final data = doc.data() as Map<String, dynamic>;
    final DateTime createdAt = (data["createdAt"] as Timestamp).toDate();
    final DateTime sendAt = (data["sendAt"] as Timestamp).toDate();

    final String formattedDate = formatDate(sendAt);
    final String timelineText = timeAgo(createdAt);

    MessageService().markAsDelivered(doc.id);

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
                          data["title"] ?? "",
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: colorScheme.onSurface,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formattedDate,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontSize: 13,
                                color: colorScheme.onSurface.withOpacity(0.5),
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Text(
                timelineText,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),

              const SizedBox(height: 16),

              Container(
                height: 1,
                color: colorScheme.onSurface.withOpacity(0.1),
              ),

              const SizedBox(height: 20),

              Text(
                data["content"] ?? "",
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
                      onTap: () async {
                        final data = doc.data() as Map<String, dynamic>;
                        await MessageService().saveMessage(doc.id, data);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _actionButton(
                      context: context,
                      label: "Sil",
                      icon: Icons.delete_outline,
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

                        if (confirm == true) {
                          try {
                            await MessageService().deleteMessage(doc.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Mesaj silindi"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Silme hatası: $e"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        }
                      },
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
                onTap: () async {
                  DateTime now = DateTime.now();

                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: now,
                    firstDate: now,
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate == null) return;

                  TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedTime == null) return;

                  final newSendAt = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );

                  final data = doc.data() as Map<String, dynamic>;

                  await MessageService().resendMessage(
                    title: data["title"] ?? "",
                    content: data["content"] ?? "",
                    newSendAt: newSendAt,
                  );

                  if (context.mounted) {
                    await AppDialogs.show(
                      context,
                      title: "Bilgi",
                      message: "Mesajınız tekrar gönderilmek üzere kaydedilmiştir..!",
                      primaryButton: "Tamam",
                      secondaryButton: null,
                    );
                  }

                  Navigator.pop(context);
                },
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
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
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
