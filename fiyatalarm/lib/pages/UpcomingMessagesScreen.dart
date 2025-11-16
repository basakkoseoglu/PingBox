import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/MessageService.dart';

class UpComingMessagesScreen extends StatefulWidget {
  const UpComingMessagesScreen({super.key});

  @override
  State<UpComingMessagesScreen> createState() => _UpComingMessagesScreenState();
}

class _UpComingMessagesScreenState extends State<UpComingMessagesScreen> {
  late Stream<QuerySnapshot> _messageStream;

  @override
  void initState() {
    super.initState();
    _messageStream = MessageService().getUpcomingMessages();
  }

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
          'Yaklaşan Mesajlar',
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
                  'Planlanmış mesajlarınız',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _messageStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Hata: ${snapshot.error}",
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 80,
                              color: colorScheme.onSurface.withOpacity(0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Henüz planlanmış mesajınız yok.",
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: colorScheme.onSurface.withOpacity(
                                      0.6,
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      );
                    }

                    final docs = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        final data = doc.data() as Map<String, dynamic>;
                        final timestamp = data["sendAt"];

                        if (timestamp == null || timestamp is! Timestamp) {
                          print("sendAt NULL veya hatalı → data: $data");
                          return const SizedBox.shrink();
                        }

                        final date = (timestamp as Timestamp).toDate();

                        return _messageCard(
                          context: context,
                          title:
                              "${date.day}.${date.month}.${date.year} - ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}",
                          content: data["content"] ?? "",
                          index: index,
                          messageId: doc.id,
                        );
                      },
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
    required int index,
    required String messageId,
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
                      _actionButton(
                        context: context,
                        icon: Icons.edit,
                        color: colorScheme.tertiary,
                        onTap: () {
                          print("Düzenleme tıklandı: $messageId");
                        },
                      ),
                      const SizedBox(height: 8),
                      _actionButton(
                        context: context,
                        icon: Icons.delete,
                        color: colorScheme.error,
                        onTap: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Mesajı Sil'),
                              content: const Text(
                                'Bu mesajı silmek istediğinizden emin misiniz?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('İptal'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    'Sil',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            try {
                              await MessageService().deleteMessage(messageId);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Mesaj silindi"),
                                    backgroundColor: Colors.orange,
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

  Widget _actionButton({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
}
