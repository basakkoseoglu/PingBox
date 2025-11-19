import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiyatalarm/components/UpComingMessage/MessageCard.dart';
import 'package:flutter/material.dart';

class UpComingMessageList extends StatelessWidget {
  final Stream<QuerySnapshot> messageStream;
  const UpComingMessageList({super.key, required this.messageStream});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return StreamBuilder<QuerySnapshot>(
      stream: messageStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: colorScheme.error),
                const SizedBox(height: 16),
                Text(
                  "Hata: ${snapshot.error}",
                  style: TextStyle(color: colorScheme.error),
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
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
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

            final date = timestamp.toDate();

            return MessageCard(
              title:
                  "${date.day}.${date.month}.${date.year} - ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}",
              content: data["content"] ?? "",
              index: index,
              messageId: doc.id,
            );
          },
        );
      },
    );
  }
}
