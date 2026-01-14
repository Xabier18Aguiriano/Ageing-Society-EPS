import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../sensors/my_sensors_screen.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('SETTINGS', style: TextStyle(fontWeight: FontWeight.w900, color: AppTheme.blue)),
              const SizedBox(height: 14),

              _SettingsTile(
                title: 'Profile',
                subtitle: 'Edit your name, age\nor profile photo',
                icon: Icons.person_rounded,
                onTap: () {},
              ),
              const SizedBox(height: 12),

              _SettingsTile(
                title: 'Connected\nfamily',
                subtitle: 'Manage who\nreceives notifications',
                icon: Icons.groups_rounded,
                onTap: () {},
              ),
              const SizedBox(height: 12),

              _SettingsTile(
                title: 'Sensor settings',
                subtitle: 'Manage NFC\nstickers and workouts hours',
                icon: Icons.nfc_rounded,
                onTap: () => Navigator.pushNamed(context, MySensorsScreen.route),
              ),
              const SizedBox(height: 12),

              _SettingsTile(
                title: 'Safety mode',
                subtitle: 'Receive alerts if\ninactivity is detected',
                icon: Icons.shield_rounded,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.circle, size: 10, color: AppTheme.green),
                    SizedBox(width: 6),
                    Text('Active', style: TextStyle(color: AppTheme.muted)),
                  ],
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 6),
                  Text(subtitle, style: const TextStyle(color: AppTheme.muted)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: AppTheme.blue.withOpacity(0.10), borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: AppTheme.blue),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 10),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
