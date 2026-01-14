import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/app_state.dart';
import '../../../theme/app_theme.dart';

class MySensorsScreen extends StatelessWidget {
  static const route = '/my-sensors';
  const MySensorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your sensors'),
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
                const Text('YOUR SENSORS', style: TextStyle(fontWeight: FontWeight.w900, color: AppTheme.blue)),
                const SizedBox(height: 6),
                const Text('Manage your home activity points', style: TextStyle(color: AppTheme.muted)),
                const SizedBox(height: 14),

                Expanded(
                  child: ListView(
                    children: app.sensors.map((s) {
                      final bg = s.connected ? AppTheme.green.withOpacity(0.12) : AppTheme.orange.withOpacity(0.14);
                      final dot = s.connected ? AppTheme.green : Colors.redAccent;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(18)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(s.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: s.connected ? Colors.green.shade900 : Colors.orange.shade900,
                                      )),
                                ),
                                Container(width: 10, height: 10, decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
                                const SizedBox(width: 8),
                                Text(s.connected ? 'Connected' : 'Disconnected', style: const TextStyle(color: AppTheme.muted)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 48,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.blue,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                      ),
                                      onPressed: () => context.read<AppState>().toggleConnect(s.id),
                                      child: Text(s.connected ? 'DISCONNECT' : 'CONNECT', style: const TextStyle(fontWeight: FontWeight.w900)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  height: 48,
                                  width: 56,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                    ),
                                    onPressed: () => context.read<AppState>().deleteSensor(s.id),
                                    child: const Icon(Icons.delete_rounded),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            if (s.connected)
                              TextButton(
                                onPressed: () => context.read<AppState>().setActiveSensor(s.id),
                                child: const Text('Set as active'),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: () => context.read<AppState>().addSensorMock(),
                          child: const Text('ADD SENSOR', style: TextStyle(fontWeight: FontWeight.w900)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
