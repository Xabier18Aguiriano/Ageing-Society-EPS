import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state/app_state.dart';
import 'theme/app_theme.dart';
import 'ui/screens/onboarding/onboarding_screen.dart';
import 'ui/screens/onboarding/profile_setup_screen.dart';
import 'ui/screens/onboarding/add_sensors_screen.dart';
import 'ui/screens/main_shell.dart';
import 'ui/screens/sensors/my_sensors_screen.dart';
import 'ui/screens/exercise/exercise_screen.dart';
import 'ui/screens/exercise/feedback_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const LiftUpApp(),
    ),
  );
}

class LiftUpApp extends StatelessWidget {
  const LiftUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LiftUp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      initialRoute: OnboardingScreen.route,
      routes: {
        OnboardingScreen.route: (_) => const OnboardingScreen(),
        ProfileSetupScreen.route: (_) => const ProfileSetupScreen(),
        AddSensorsScreen.route: (_) => const AddSensorsScreen(),

        MainShell.route: (_) => const MainShell(),
        MySensorsScreen.route: (_) => const MySensorsScreen(),
        ExerciseScreen.route: (_) => const ExerciseScreen(),
        FeedbackScreen.route: (_) => const FeedbackScreen(),
      },
    );
  }
}
