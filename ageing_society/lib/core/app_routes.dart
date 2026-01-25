import 'package:flutter/material.dart';
import '../ui/screens/onboarding/onboarding_screen.dart';
import '../ui/screens/setup_screen.dart';
import '../ui/screens/stickers_screen.dart';
import '../ui/screens/home_screen.dart';
import '../ui/screens/settings_screen.dart';
import '../ui/screens/routine_screen.dart';
import '../ui/screens/profile_screen.dart';
class AppRoutes {
  static const onboarding = '/';
  static const setup = '/setup';
  static const stickers = '/stickers';
  static const home = '/home';
  static const settings = '/settings';
  static const routine = '/routine';
  static const profile = '/profile';

  static Map<String, WidgetBuilder> routes = {
    onboarding: (_) => const OnboardingScreen(),
    setup: (_) => const SetupScreen(),
    stickers: (_) => const StickersScreen(),
    home: (_) => const HomeScreen(),
    settings: (_) => const SettingsScreen(),
    routine: (_) => const RoutineScreen(),
    profile: (_) => const ProfileScreen(),
  };
}
