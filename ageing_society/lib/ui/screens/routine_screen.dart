import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/app_state.dart';
import '../../../theme/app_theme.dart';
import './exercise/exercise_screen.dart';

class RoutineScreen extends StatelessWidget {
  static const route = '/routine';
  const RoutineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final sensor = app.currentRoutineSensor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Routine'),
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
                const Text(
                  'MINI ROUTINE',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    color: AppTheme.blue,
                  ),
                ),
                const SizedBox(height: 10),

                if (sensor != null) ...[
                  Text(
                    'Go to this sensor:',
                    style: const TextStyle(color: AppTheme.muted),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    sensor.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.orange,
                    ),
                  ),
                ] else ...[
                  const Text(
                    'Routine finished 🎉',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.green,
                    ),
                  ),
                ],

                const Spacer(),

                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      if (app.isRoutineFinished) {
                        app.resetRoutine();
                        Navigator.pop(context); // vuelve a Home
                        return;
                      }

                      final sensor =  app.currentRoutineSensor!;
                      app.toggleActiveSensor(sensor.id);
                      app.startRandomExercise();

                      Navigator.pushNamed(context, ExerciseScreen.route);
                    },
                    child: Text(
                      sensor == null
                          ? 'FINISH'
                          : 'SCAN SENSOR FOR EXERCISE',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
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
