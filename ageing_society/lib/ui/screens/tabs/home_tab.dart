import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/app_state.dart';
import '../../../theme/app_theme.dart';
import '../exercise/exercise_screen.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final active = app.activeSensor;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Card(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Today's activity", style: TextStyle(color: AppTheme.muted)),
                          const SizedBox(height: 6),
                          Text(
                            '${app.todayExercises} exercises',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.blue),
                          ),
                          const SizedBox(height: 6),
                          const Text('Great job! Keep it up', style: TextStyle(color: AppTheme.muted)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              SizedBox(
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    context.read<AppState>().startRandomExercise();
                    Navigator.pushNamed(context, ExerciseScreen.route);
                  },
                  child: const Text(
                    'Scan sensor for\nexercise',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                ),
              ),

              const SizedBox(height: 18),
              const Text('Your sensors', style: TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),

              _Card(
                child: Row(
                  children: [
                    Expanded(child: Text(active?.name ?? 'No active sensor', style: const TextStyle(fontWeight: FontWeight.w800))),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: active != null ? AppTheme.green : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(active != null ? 'Active' : 'Inactive', style: const TextStyle(color: AppTheme.muted)),
                  ],
                ),
              ),

              const SizedBox(height: 18),
              const Text('Family messages', style: TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),

              _Card(
                child: const Text('Ana: Great job today!', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(blurRadius: 18, color: Color(0x12000000), offset: Offset(0, 10)),
        ],
      ),
      child: child,
    );
  }
}
