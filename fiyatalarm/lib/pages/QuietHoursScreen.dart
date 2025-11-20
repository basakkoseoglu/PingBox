import 'package:fiyatalarm/Models/QuietHours.dart';
import 'package:fiyatalarm/providers/UserAuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuietHoursScreen extends StatefulWidget {
  const QuietHoursScreen({super.key});

  @override
  State<QuietHoursScreen> createState() => _QuietHoursScreenState();
}

class _QuietHoursScreenState extends State<QuietHoursScreen> {
  late QuietHours _quietHours;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<UserAuthProvider>(context, listen: false);
    _quietHours = authProvider.quietHours;
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _quietHours.startTime : _quietHours.endTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _quietHours = _quietHours.copyWith(startTime: picked);
        } else {
          _quietHours = _quietHours.copyWith(endTime: picked);
        }
      });
    }
  }

  Future<void> _saveSettings() async {
    setState(() => _isLoading = true);

    final authProvider = Provider.of<UserAuthProvider>(context, listen: false);
    final success = await authProvider.updateQuietHours(_quietHours);

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sessiz saatler kaydedildi'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Sessiz Saatler',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
        ),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(right: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveSettings,
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Açıklama kartı
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.primary.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.nightlight_round,
                  color: colorScheme.primary,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Sessiz saatler aktifken bildirimler ertelenir ve belirlediğiniz süre bitince toplu olarak gösterilir.',
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Sessiz Saatleri Aktif/Pasif yap
          Card(
            elevation: 0,
            color: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: SwitchListTile(
              secondary: Icon(
                _quietHours.enabled ? Icons.notifications_off : Icons.notifications_active,
                color: colorScheme.primary,
              ),
              title: const Text(
                'Sessiz Saatleri Aktif Et',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                _quietHours.enabled
                    ? 'Bildirimler ertelenecek'
                    : 'Tüm bildirimleri alacaksınız',
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              value: _quietHours.enabled,
              onChanged: (value) {
                setState(() {
                  _quietHours = _quietHours.copyWith(enabled: value);
                });
              },
              activeColor: colorScheme.primary,
            ),
          ),

          if (_quietHours.enabled) ...[
            const SizedBox(height: 24),

            Text(
              'Sessiz Saat Aralığı',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),

            const SizedBox(height: 12),

            // Başlangıç Saati
            _buildTimeCard(
              context,
              title: 'Başlangıç Saati',
              time: _quietHours.startTime,
              icon: Icons.bedtime,
              onTap: () => _selectTime(context, true),
            ),

            const SizedBox(height: 12),

            // Bitiş Saati
            _buildTimeCard(
              context,
              title: 'Bitiş Saati',
              time: _quietHours.endTime,
              icon: Icons.wb_sunny,
              onTap: () => _selectTime(context, false),
            ),

            const SizedBox(height: 24),

            // Örnek gösterim
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Aktif Sessiz Saat',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _quietHours.getDisplayText(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getQuietHoursDuration(),
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeCard(
    BuildContext context, {
    required String title,
    required TimeOfDay time,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final timeString = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timeString,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurface.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getQuietHoursDuration() {
    final startMinutes = _quietHours.startTime.hour * 60 + _quietHours.startTime.minute;
    final endMinutes = _quietHours.endTime.hour * 60 + _quietHours.endTime.minute;
    
    int durationMinutes;
    if (startMinutes > endMinutes) {
      // Gece yarısını geçiyor
      durationMinutes = (24 * 60 - startMinutes) + endMinutes;
    } else {
      durationMinutes = endMinutes - startMinutes;
    }
    
    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;
    
    if (minutes == 0) {
      return '$hours saat boyunca bildirimler sessiz olacak';
    } else {
      return '$hours saat $minutes dakika boyunca bildirimler sessiz olacak';
    }
  }
}