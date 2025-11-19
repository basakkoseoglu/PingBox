import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiyatalarm/pages/AuthScreen.dart';
import 'package:flutter/material.dart';

import '../services/AuthService.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser; 
    final email = user?.email ?? "Email bulunamadı";
    final colorScheme = Theme.of(context).colorScheme;
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
                child: const CircleAvatar(
                  radius: 55,
                  backgroundImage: AssetImage("assets/logo/flogo.jpg"),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              email,
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
              onTap: () {},
            ),

            _settingsTile(
              context,
              icon: Icons.nights_stay_outlined,
              title: "Sessiz Saatler",
              onTap: () {},
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
