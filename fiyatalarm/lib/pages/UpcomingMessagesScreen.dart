import 'package:fiyatalarm/components/UpComingMessage/UpcomingMessageList.dart';
import 'package:fiyatalarm/providers/MessageProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpComingMessagesScreen extends StatelessWidget {
  const UpComingMessagesScreen({super.key});

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
          'Yaklaşan Mesajlar',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
        ),
        actions: [
          // ✅ Yenile butonu ekle
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
              child: messageProvider.upcomingMessagesStream == null
                  ? const Center(child: CircularProgressIndicator())
                  : UpComingMessageList(
                      messageStream: messageProvider.upcomingMessagesStream!,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
