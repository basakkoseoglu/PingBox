import 'package:flutter/material.dart';

class AIHomeHeader extends StatelessWidget {
  final String username;
  final String? avatarUrl;

  const AIHomeHeader({super.key, required this.username, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            scheme.primary.withOpacity(0.10),
            scheme.secondary.withOpacity(0.08),
          ],
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundImage:
                (avatarUrl != null && avatarUrl!.startsWith('http'))
                ? NetworkImage(avatarUrl!)
                : AssetImage(
                        avatarUrl != null && avatarUrl!.isNotEmpty
                            ? avatarUrl!
                            : "assets/avatars/avatar_default.png",
                      )
                      as ImageProvider,
          ),

          const SizedBox(width: 16),

          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Merhaba, $username",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: scheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "Bugünkü AI koçun hazır.",
                  style: TextStyle(
                    fontSize: 16,
                    color: scheme.onSurface.withOpacity(0.7),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
