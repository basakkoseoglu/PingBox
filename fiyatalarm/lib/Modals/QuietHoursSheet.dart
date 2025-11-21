import 'package:fiyatalarm/components/ProfileScreen/QuietHoursComponent/QuietHoursDurationInfo.dart';
import 'package:fiyatalarm/components/ProfileScreen/QuietHoursComponent/QuietHoursHeader.dart';
import 'package:fiyatalarm/components/ProfileScreen/QuietHoursComponent/QuietHoursSaveButton.dart';
import 'package:fiyatalarm/components/ProfileScreen/QuietHoursComponent/QuietHoursSwitch.dart';
import 'package:fiyatalarm/components/ProfileScreen/QuietHoursComponent/QuietHoursTimeCard.dart';
import 'package:fiyatalarm/providers/QuietHoursProvider.dart';
import 'package:fiyatalarm/providers/UserAuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuietHoursSheet {
  static void show(BuildContext context) {
    final user = Provider.of<UserAuthProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ChangeNotifierProvider(
          create: (_) => QuietHoursProvider(user.quietHours),
          child: const _QuietHoursContent(),
        );
      },
    );
  }
}

class _QuietHoursContent extends StatelessWidget {
  const _QuietHoursContent();

  Future<void> _pickTime(
    BuildContext context,
    bool isStart,
    QuietHoursProvider provider,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart
          ? provider.quietHours.startTime
          : provider.quietHours.endTime,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );

    if (picked != null) {
      isStart ? provider.updateStart(picked) : provider.updateEnd(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuietHoursProvider>(context);
    final color = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: SizedBox(
                      width: 40,
                      height: 4,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const QuietHoursHeader(),
                  const SizedBox(height: 24),

                  QuietHoursSwitch(
                    enabled: provider.quietHours.enabled,
                    onChanged: provider.toggleEnabled,
                  ),

                  if (provider.quietHours.enabled) ...[
                    const SizedBox(height: 24),

                    Text(
                      "SAAT ARALIĞI",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: color.onSurface.withOpacity(0.5),
                      ),
                    ),

                    const SizedBox(height: 12),

                    QuietHoursTimeCard(
                      title: "Başlangıç Saati",
                      time: provider.quietHours.startTime,
                      icon: Icons.bedtime,
                      onTap: () => _pickTime(context, true, provider),
                    ),

                    const SizedBox(height: 12),

                    QuietHoursTimeCard(
                      title: "Bitiş Saati",
                      time: provider.quietHours.endTime,
                      icon: Icons.wb_sunny,
                      onTap: () => _pickTime(context, false, provider),
                    ),

                    const SizedBox(height: 20),

                    QuietHoursDurationInfo(
                      durationText: provider.durationText,
                      warningText: provider.warningText,
                    ),

                    const SizedBox(height: 24),

                    QuietHoursSaveButton(
                      label: provider.isLoading ? "Kaydediliyor..." : "Kaydet",
                      color: color.primary,
                      fullWidth: true,
                      onTap: provider.isLoading
                          ? null
                          : () async {
                              bool ok = await provider.save();
                              if (!context.mounted) return;

                              if (ok) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text("Sessiz saat dilimi ayarlanmıştır.",),
                                  ),
                                );
                              }
                            },
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
