import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class BottomNav extends StatelessWidget {
  // New flexible API:
  final int? index;
  final void Function(int)? onChanged;

  // Backwards-compatibility if you used these names elsewhere:
  final int? currentIndex;
  final void Function(int)? onTap;

  const BottomNav({
    super.key,
    this.index,
    this.onChanged,
    this.currentIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIndex = index ?? currentIndex ?? 0;
    final effectiveOnChanged = onChanged ?? onTap ?? (_) {};

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              blurRadius: 20,
              color: Color(0x14000000),
              offset: Offset(0, 10),
            )
          ],
        ),
        child: NavigationBar(
          selectedIndex: effectiveIndex,
          onDestinationSelected: effectiveOnChanged,
          backgroundColor: Colors.white,
          indicatorColor: AppTheme.blue.withOpacity(0.15),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_rounded), label: 'HOME'),
            NavigationDestination(icon: Icon(Icons.show_chart_rounded), label: 'ACTIVITY'),
            NavigationDestination(icon: Icon(Icons.settings_rounded), label: 'SETTINGS'),
          ],
        ),
      ),
    );
  }
}
