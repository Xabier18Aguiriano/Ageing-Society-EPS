import 'package:flutter/material.dart';
import '../screens/onboarding_screen.dart';
import '../screens/setup_screen.dart';
import '../screens/stickers_screen.dart';
import '../screens/home_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/routine_screen.dart';

class AppRoutes {
  static const onboarding = '/';
  static const setup = '/setup';
  static const stickers = '/stickers';
  static const home = '/home';
  static const settings = '/settings';
  static const routine = '/routine';

  static Map<String, WidgetBuilder> routes = {
    onboarding: (_) => const OnboardingScreen(),
    setup: (_) => const SetupScreen(),
    stickers: (_) => const StickersScreen(),
    home: (_) => const HomeScreen(),
    settings: (_) => const SettingsScreen(),
    routine: (_) => const RoutineScreen(),
  };
}
