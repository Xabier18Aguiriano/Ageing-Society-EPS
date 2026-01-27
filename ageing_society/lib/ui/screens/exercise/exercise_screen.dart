import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../state/app_state.dart';
import '../../../theme/app_theme.dart';
import 'feedback_screen.dart';

class ExerciseScreen extends StatefulWidget {
  static const route = '/exercise';
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  VideoPlayerController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final exercise = context.read<AppState>().currentExercise;

    if (exercise != null) {
      _controller?.dispose();
      _controller = VideoPlayerController.asset(exercise.video)
        ..setLooping(true)
        ..initialize().then((_) {
          if (!mounted) return;
          setState(() {});
          _controller!.play();
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final exercise = app.currentExercise;

    if (exercise == null) {
      return const Scaffold(
        body: Center(child: Text('No exercise')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise'),
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
                // NOMBRE DEL EJERCICIO CENTRADO
                Center(
                  child: Text(
                    exercise.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.orange,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 🎥 VIDEO CARD (FULL FRAME)
                Container(
                  height: 260,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: _controller != null && _controller!.value.isInitialized
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: _controller!.value.size.width,
                              height: _controller!.value.size.height,
                              child: VideoPlayer(_controller!),
                            ),
                          ),
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
                const SizedBox(height: 20),

                // DESCRIPCIÓN CENTRADA Y MÁS GRANDE
                Center(
                  child: Text(
                    exercise.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppTheme.muted,
                      height: 1.5,
                    ),
                  ),
                ),

                const Spacer(),

                // BOTÓN "I'M DONE"
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      app.nextRoutineSensor();
                      Navigator.pushNamed(context, FeedbackScreen.route);
                    },
                    child: const Text(
                      "I'M DONE",
                      style: TextStyle(
                        fontSize: 18,
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