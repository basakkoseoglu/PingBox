import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pingbox/Modals/MessageDetail.dart';
import 'package:pingbox/components/Notification/EmpytMessage.dart';
import 'package:pingbox/components/Notification/MessageCard.dart';
import 'package:pingbox/providers/MessageProvider.dart';
import 'package:pingbox/services/MessageService.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final messageProvider = context.watch<MessageProvider>();

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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<MessageProvider>().refreshStreams();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gelen mesajlarınız',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: messageProvider.archiveMessagesStream == null
                  ? const Center(child: CircularProgressIndicator())
                  : StreamBuilder<QuerySnapshot>(
                      stream: messageProvider.archiveMessagesStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              "Hata: ${snapshot.error}",
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const EmptyMessage(
                            message: "Henüz arşivlenmiş mesajın yok.",
                            icon: Icons.mail_outline,
                          );
                        }

                        final docs = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final doc = docs[index];
                            final data = doc.data() as Map<String, dynamic>;

                            return MessageCard(
                              messageId: doc.id,
                              title: data["title"] ?? "",
                              content: data["content"] ?? "",
                              date: data['sendAt'].toDate(),
                              index: index,
                              onTap: () {
                                MessageService().markAsDelivered(doc.id);
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => MessageDetailModal(doc: doc),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
