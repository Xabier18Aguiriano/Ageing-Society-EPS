import 'package:flutter/material.dart';

import '../widgets/bottom_nav.dart';
import 'tabs/home_tab.dart';
import 'tabs/activity_tab.dart';
import 'tabs/settings_tab.dart';

class MainShell extends StatefulWidget {
  static const route = '/main';
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int navIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = const [
      HomeTab(),
      ActivityTab(),
      SettingsTab(),
    ];

    return Scaffold(
      body: SafeArea(
        child: pages[navIndex],
      ),
      bottomNavigationBar: BottomNav(
        index: navIndex,
        onChanged: (i) {
          setState(() {
            navIndex = i;
          });
        },
      ),
    );
  }
}
