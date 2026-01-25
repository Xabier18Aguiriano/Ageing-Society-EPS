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

    if (exercise != null && _controller == null) {
      _controller = VideoPlayerController.asset(exercise.video)
        ..initialize().then((_) {
          _controller!.setLooping(true);
          _controller!.play();
          setState(() {});
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
            child: exercise == null
                ? const Center(child: Text('No exercise selected'))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "LET'S START!",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: AppTheme.blue,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Exercise detected from ${app.activeSensor?.name ?? "Kitchen Sticker"}',
                        style: const TextStyle(color: AppTheme.muted),
                      ),
                      const SizedBox(height: 14),

                      // VIDEO
                      Container(
                        height: 240,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: _controller != null &&
                                _controller!.value.isInitialized
                            ? FittedBox(
                                fit: BoxFit.cover,
                                child: SizedBox(
                                  width:
                                      _controller!.value.size.width,
                                  height:
                                      _controller!.value.size.height,
                                  child: VideoPlayer(_controller!),
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                      ),

                      const SizedBox(height: 14),

                      Text(
                        exercise.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.orange,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        exercise.description,
                        style: const TextStyle(
                          color: AppTheme.muted,
                          height: 1.3,
                        ),
                      ),

                      const Spacer(),

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
                          onPressed: () => Navigator.pushNamed(
                            context,
                            FeedbackScreen.route,
                          ),
                          child: const Text(
                            "I'M DONE",
                            style: TextStyle(
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
