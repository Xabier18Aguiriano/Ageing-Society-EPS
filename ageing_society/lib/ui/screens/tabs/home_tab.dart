import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/app_state.dart';
import '../../../theme/app_theme.dart';
import '../routine_screen.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Escucha AppState para reconstruir la UI al cambiar sensores
    final app = context.watch<AppState>();
    final connectedSensors = app.sensors.where((s) => s.connected).toList();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 🎯 Today's activity
              _Card(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Today's activity",
                            style: TextStyle(color: AppTheme.muted),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${app.todayExercises} exercises',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.blue,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Great job! Keep it up',
                            style: TextStyle(color: AppTheme.muted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ▶ START ROUTINE BUTTON
              SizedBox(
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    final app = context.read<AppState>();

                    app.startRoutine();

                    if (app.currentRoutineSensor == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No active sensors available'),
                        ),
                      );
                      return;
                    }
                    Navigator.pushNamed(context, RoutineScreen.route);
                  },
                  child: const Text(
                    'START ROUTINE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // 🎯 YOUR SENSORS
              const Text('Your sensors',
                  style: TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),

              // 🌟 Scrollable container with max height
              Container(
                constraints: const BoxConstraints(
                  maxHeight: 200, // Máximo alto para no ocupar toda la pantalla
                ),
                child: _Card(
                  child: connectedSensors.isEmpty
                      ? const Text(
                          'No connected sensors',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        )
                      : Scrollbar(
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            child: Column(
                              children: connectedSensors.map((sensor) {
                                return InkWell(
                                  onTap: () {
                                    // Cambia el estado activo/inactivo al tocar
                                    app.toggleActiveSensor(sensor.id);
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 4),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            sensor.name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: sensor.active
                                                ? AppTheme.green
                                                : Colors.grey,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          sensor.active ? 'Active' : 'Inactive',
                                          style: const TextStyle(
                                              color: AppTheme.muted),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 18),

              // 🎯 Family messages
              const Text('Family messages',
                  style: TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              _Card(
                child: const Text('Ana: Great job today!',
                    style: TextStyle(fontWeight: FontWeight.w700)),
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
          BoxShadow(
            blurRadius: 18,
            color: Color(0x12000000),
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}