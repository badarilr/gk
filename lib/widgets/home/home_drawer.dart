import 'package:flutter/material.dart';

import '../celebration_overlay.dart';
import 'home_actions.dart';

/// Navigation drawer for the home tab (channels + celebration shortcut).
class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  static const _goonjanChannel =
      'https://www.youtube.com/@goonjankalakendra';
  static const _jyothiChannel = 'https://www.youtube.com/@jyotihegde-n6f';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.asset(
                        'assets/logo/gk.png',
                        width: 48,
                        height: 48,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.music_note,
                          size: 40,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Goonjan Kalakendra',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Music practice companion',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onPrimaryContainer.withValues(
                        alpha: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _DrawerLinkTile(
              icon: Icons.smart_display_outlined,
              title: 'Goonjan Kala Kendra',
              subtitle: 'YouTube channel',
              onTap: () {
                Navigator.pop(context);
                HomeActions.launchChannel(_goonjanChannel);
              },
            ),
            _DrawerLinkTile(
              icon: Icons.smart_display_outlined,
              title: 'Jyothi Hegde',
              subtitle: 'YouTube channel',
              onTap: () {
                Navigator.pop(context);
                HomeActions.launchChannel(_jyothiChannel);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Divider(color: colorScheme.outlineVariant),
            ),
            _DrawerLinkTile(
              icon: Icons.celebration_outlined,
              title: 'SUPER BUZZER!',
              subtitle: 'Play celebration overlay',
              iconColor: colorScheme.primary,
              onTap: () {
                Navigator.pop(context);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!context.mounted) return;
                  CelebrationOverlay.show(
                    context,
                    title: 'SUPER BUZZER!',
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerLinkTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;

  const _DrawerLinkTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? colorScheme.onSurfaceVariant),
        title: Text(title),
        subtitle: Text(subtitle),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: onTap,
      ),
    );
  }
}
