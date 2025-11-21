import 'package:fiyatalarm/components/Diaologs/CustomConfirmDialog.dart';
import 'package:fiyatalarm/providers/NotificationPermissionProvider.dart';
import 'package:fiyatalarm/services/NotificationPermissionService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationPermissionSheet {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ChangeNotifierProvider(
          create: (_) => NotificationPermissionProvider(),
          child: const _Content(),
        );
      },
    );
  }
}

class _Content extends StatefulWidget {
  const _Content();

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<NotificationPermissionProvider>().loadStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationPermissionProvider>(context);
    final color = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: color.onSurface.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              provider.isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(),
                    )
                  : _PermissionBody(provider: provider),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionBody extends StatelessWidget {
  final NotificationPermissionProvider provider;

  const _PermissionBody({required this.provider});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final enabled = provider.isEnabled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: enabled
                    ? color.primary.withOpacity(0.12)
                    : color.error.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                enabled
                    ? Icons.notifications_active
                    : Icons.notifications_off_outlined,
                color: enabled ? color.primary : color.error,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                enabled ? 'Bildirimler Açık' : 'Bildirimler Kapalı',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        Container(height: 1, color: color.onSurface.withOpacity(0.1)),

        const SizedBox(height: 20),

        Text(
          enabled
              ? 'Bildirim izni verildi. Mesajlarınızı tam vaktinde alacaksınız.'
              : 'Önemli mesajları kaçırmamak için bildirim izni vermeniz önerilir.',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontSize: 15, height: 1.6),
        ),

        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(
              child: _actionButton(
                context: context,
                label: "Yenile",
                icon: Icons.refresh,
                color: color.secondary,
                onTap: () async => await provider.refresh(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _actionButton(
                context: context,
                label: enabled ? "Ayarlara Git" : "İzin Ver",
                icon: enabled ? Icons.settings : Icons.notifications,
                color: enabled ? color.primary : color.error,
                onTap: enabled
                    ? () async =>
                          await NotificationPermissionService.openSettings()
                    : () async {
                        final status = await provider.requestPermission();
                        if (!context.mounted) return;

                        if (status.name == 'denied') {
                          final result = await AppDialogs.show(
                            context,
                            title: 'Bildirim İzni',
                            message: 'Bildirimleri açmak için ayarlara gidin.',
                            primaryButton: 'Ayarlara Git',
                            secondaryButton: 'İptal',
                            primaryColor: color.primary,
                          );

                          if (result == true) {
                            NotificationPermissionService.openSettings();
                          }
                        } else if (status.name == 'authorized') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Bildirimler açıldı ✓'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),
      ],
    );
  }

  Widget _actionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required Future<void> Function() onTap,
  }) {
    return InkWell(
      onTap: () async => await onTap(),
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
