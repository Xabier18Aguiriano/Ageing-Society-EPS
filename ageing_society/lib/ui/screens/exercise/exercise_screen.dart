import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/app_state.dart';
import '../../../theme/app_theme.dart';
import 'feedback_screen.dart';

class ExerciseScreen extends StatelessWidget {
  static const route = '/exercise';
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises'),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text("LET'S START!", style: TextStyle(fontWeight: FontWeight.w900, color: AppTheme.blue)),
                const SizedBox(height: 6),
                Text(
                  'Exercise detected from ${app.activeSensor?.name ?? "Kitchen Sticker"}',
                  style: const TextStyle(color: AppTheme.muted),
                ),
                const SizedBox(height: 14),

                // Photo card
                Container(
                  height: 240,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    image: DecorationImage(
                      image: const AssetImage('assets/images/exercise_photo.jpg'),
                      fit: BoxFit.cover,
                      onError: (_, __) {},
                    ),
                  ),
                  child: const SizedBox(),
                ),
                const SizedBox(height: 14),

                Text(app.currentExerciseTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.orange)),
                const SizedBox(height: 8),
                Text(
                  app.currentExerciseHint,
                  style: const TextStyle(color: AppTheme.muted, height: 1.3),
                ),

                const Spacer(),

                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () => Navigator.pushNamed(context, FeedbackScreen.route),
                    child: const Text("I'M DONE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
