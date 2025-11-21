import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fiyatalarm/providers/ThemeProvider.dart';

class ThemeSheet {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ThemeSheetContent(),
    );
  }
}

class _ThemeSheetContent extends StatelessWidget {
  const _ThemeSheetContent();

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final color = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
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

              Row(
                children: [
                  Container( padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:color.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.color_lens_outlined,
                color: color.primary,
                size: 24,
              ),),
              SizedBox(width: 10,),
                  Text(
                    "Tema Seçimi",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _themeOption(
                context,
                title: "Açık Tema",
                icon: Icons.light_mode,
                selected: themeProvider.themeMode == ThemeMode.light,
                onTap: () {
                  themeProvider.setLightTheme();
                  Navigator.pop(context);
                },
              ),

              _themeOption(
                context,
                title: "Koyu Tema",
                icon: Icons.dark_mode,
                selected: themeProvider.themeMode == ThemeMode.dark,
                onTap: () {
                  themeProvider.setDarkTheme();
                  Navigator.pop(context);
                },
              ),

              _themeOption(
                context,
                title: "Sistem Teması",
                icon: Icons.phone_android,
                selected: themeProvider.themeMode == ThemeMode.system,
                onTap: () {
                  themeProvider.setSystemTheme();
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _themeOption(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final color = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: selected
              ? color.primary.withOpacity(0.1)
              : color.surfaceVariant.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? color.primary
                : color.onSurface.withOpacity(0.15),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(
              icon,
              color: selected ? color.primary : color.onSurface,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:
                          selected ? color.primary : color.onSurface,
                    ),
              ),
            ),
            if (selected)
              Icon(Icons.check, color: color.primary),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
