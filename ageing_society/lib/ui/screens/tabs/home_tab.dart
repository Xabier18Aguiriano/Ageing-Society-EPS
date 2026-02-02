import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../state/app_state.dart';
import '../../../theme/app_theme.dart';
import '../routine_screen.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hoy ejercicios
              _Card(
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
              const SizedBox(height: 14),

              // Botón start routine
              SizedBox(
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    app.startRoutine();
                    if (app.currentRoutineSensor == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No active sensors available')),
                      );
                      return;
                    }
                    Navigator.pushNamed(context, RoutineScreen.route);
                  },
                  child: const Text(
                    'START ROUTINE',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // LISTA DE SENSORES (scroll independiente)
              const Text('Your sensors', style: TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              SizedBox(
                height: 200, // altura máxima para scroll
                child: ListView.separated(
                  itemCount: app.sensors.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final s = app.sensors[i];
                    return InkWell(
                      onTap: () => app.toggleActiveSensor(s.id),
                      child: _Card(
                        child: Row(
                          children: [
                            Expanded(child: Text(s.name, style: const TextStyle(fontWeight: FontWeight.w800))),
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: s.active ? AppTheme.green : Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(s.active ? 'Active' : 'Inactive', style: const TextStyle(color: AppTheme.muted)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),

              // LISTA DE MENSAJES FAMILIARES (scroll independiente)
              const Text('Family messages', style: TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              const Text('Messages sent to your family contacts', style: TextStyle(color: AppTheme.muted)),
              const SizedBox(height: 10),
              Expanded(
                child: app.familyMessages.isEmpty
                    ? const Center(
                        child: Text(
                          'No messages yet',
                          style: TextStyle(color: AppTheme.muted),
                        ),
                      )
                    : ListView.separated(
                        itemCount: app.familyMessages.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final msg = app.familyMessages[i];
                          return _Card(
                            child: Text(
                              msg,
                              style: const TextStyle(
                                color: AppTheme.green,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          );
                        },
                      ),
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
        boxShadow: const [BoxShadow(blurRadius: 18, color: Color(0x12000000), offset: Offset(0, 10))],
      ),
      child: child,
    );
  }
}