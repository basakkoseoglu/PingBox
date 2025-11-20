import 'package:fiyatalarm/pages/AuthScreen.dart';
import 'package:fiyatalarm/pages/NotificationPermissionScreen.dart';
import 'package:fiyatalarm/pages/QuietHoursScreen.dart';
import 'package:fiyatalarm/providers/UserAuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/AuthService.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final authProvider = Provider.of<UserAuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Profil',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            Center(
              child: GestureDetector(
                onTap: () {
                  _showAvatarSelectionDialog(context);
                },
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.primary.withOpacity(0.3),
                      width: 3,
                    ),
                  ),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundImage: AssetImage(authProvider.avatarPath),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.edit,
                            size: 20,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              authProvider.username,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),

            const SizedBox(height: 30),

            _settingsTile(
              context,
              icon: Icons.notifications_none,
              title: "Bildirim İzinleri",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationPermissionScreen(),
                  ),
                );
              },
            ),

            _settingsTile(
              context,
              icon: Icons.nights_stay_outlined,
              title: "Sessiz Saatler",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QuietHoursScreen(),
                  ),
                );
              },
            ),

            _settingsTile(
              context,
              icon: Icons.color_lens_outlined,
              title: "Tema",
              onTap: () {},
            ),
            _settingsTile(
              context,
              icon: Icons.favorite_border,
              title: "Favori Mesajlar",
              onTap: () {},
            ),

            const SizedBox(height: 10),

            ListTile(
              leading: Icon(Icons.logout, color: colorScheme.error),
              title: Text(
                "Çıkış Yap",
                style: TextStyle(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () async {
                await AuthService().signOut();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAvatarSelectionDialog(BuildContext context) {
    final authProvider = Provider.of<UserAuthProvider>(context, listen: false);

    final avatars = [
      'assets/avatars/avatar_default.png',
      'assets/avatars/avatar_1.png',
      'assets/avatars/avatar_2.png',
      'assets/avatars/avatar_3.png',
      'assets/avatars/avatar_4.png',
      'assets/avatars/avatar_5.png',
      'assets/avatars/avatar_6.png',
      'assets/avatars/avatar_7.png',
      'assets/avatars/avatar_8.png',
      'assets/avatars/avatar_9.png',
      'assets/avatars/avatar_10.png',
      'assets/avatars/avatar_11.png',
      'assets/avatars/avatar_12.png',
      'assets/avatars/avatar_13.png',
      'assets/avatars/avatar_14.png',
      'assets/avatars/avatar_15.png',
      'assets/avatars/avatar_16.png',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Avatar Seç'),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: avatars.length,
            itemBuilder: (context, index) {
              final avatar = avatars[index];
              final isSelected = authProvider.avatarPath == avatar;

              return GestureDetector(
                onTap: () async {
                  final success = await authProvider.updateAvatar(avatar);
                  if (success && context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Avatar güncellendi!')),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: CircleAvatar(backgroundImage: AssetImage(avatar)),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
        ],
      ),
    );
  }

  Widget _settingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: Icon(icon, color: Theme.of(context).iconTheme.color),
          title: Text(title),
          trailing: const Icon(Icons.chevron_right),
        ),
        Divider(
          height: 1,
          thickness: 0.5,
          color: Theme.of(context).dividerColor.withOpacity(0.4),
        ),
      ],
    );
  }
}
