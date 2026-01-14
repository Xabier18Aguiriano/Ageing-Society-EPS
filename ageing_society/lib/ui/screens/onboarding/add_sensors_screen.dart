import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/app_state.dart';
import '../../../theme/app_theme.dart';
import '../main_shell.dart';

class AddSensorsScreen extends StatelessWidget {
  static const route = '/add-sensors';
  const AddSensorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 18),
                  const Text(
                    'ADD YOUR SENSORS',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.blue),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Place your phone near a sensor to connect it',
                    style: TextStyle(color: AppTheme.muted),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Icon card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 18,
                          color: Color(0x14000000),
                          offset: Offset(0, 10),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.nfc_rounded, size: 48),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: () {
                              // Mock scan: adds a sensor
                              context.read<AppState>().addSensorMock();
                            },
                            child: const Text('Scan sensor', style: TextStyle(fontWeight: FontWeight.w800)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Sensors list
                  Expanded(
                    child: ListView(
                      children: app.sensors.map((s) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(s.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                              ),
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: s.connected ? AppTheme.green : Colors.redAccent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                s.connected ? 'Connected' : 'Disconnected',
                                style: const TextStyle(fontSize: 12, color: AppTheme.muted),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Text(
                    'You can add more stickers later in the Settings',
                    style: TextStyle(fontSize: 12, color: AppTheme.muted),
                  ),
                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          MainShell.route,
                          (r) => false,
                        );
                      },
                      child: const Text('CONTINUE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
