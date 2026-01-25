import 'package:flutter/material.dart';
import '../models/sensor.dart';
import '../models/exercise.dart';
import 'dart:math';

class AppState extends ChangeNotifier {
  // Profile
  String name = '';
  String yearOfBirth = '';
  String country = '';

  // Sensors
  final List<Sensor> sensors = [
    Sensor(id: 'kitchen', name: 'Kitchen sensor', connected: true, active: true),
    Sensor(id: 'bedroom', name: 'Bedroom sensor', connected: true, active: false),
  ];

  // Activity mock
  int todayExercises = 3;
  int weeklyMovements = 18;

  // Exercise flow
  String currentExerciseTitle = 'Lift your knees 5 times';
  String currentExerciseHint =
      'Hold the counter or a chair for stability.\nRaise each knee slowly until hip height.';

  void setProfile({
    required String name,
    required String yob,
    required String country,
  }) {
    this.name = name;
    yearOfBirth = yob;
    this.country = country;
    notifyListeners();
  }

  // UPDATED METHOD
  void addSensorMock({required String name}) {
    final id = 'sensor_${DateTime.now().millisecondsSinceEpoch}';

    sensors.add(
      Sensor(
        id: id,
        name: name,
        connected: true,
        active: false,
      ),
    );

    notifyListeners();
  }

  void toggleConnect(String id) {
    final s = sensors.firstWhere((x) => x.id == id);
    s.connected = !s.connected;
    if (!s.connected) s.active = false;
    notifyListeners();
  }

  void deleteSensor(String id) {
    sensors.removeWhere((x) => x.id == id);
    notifyListeners();
  }

  void setActiveSensor(String id) {
    for (final s in sensors) {
      s.active = (s.id == id) && s.connected;
    }
    notifyListeners();
  }

  Sensor? get activeSensor {
    try {
      return sensors.firstWhere((s) => s.active);
    } catch (_) {
      return null;
    }
  }
}

// Exercises (mock database)
final List<Exercise> exercises = [
  Exercise(
    id: 'ex_fist_squeezing',
    name: 'Fist squeezing',
    description:
        'Gently close your fists and hold for 3 seconds. '
        'Release completely and stretch the fingers. '
        'Repeat 10 times.',
  ),

  Exercise(
    id: 'ex_finger_tapping',
    name: 'Finger tapping',
    description:
        'Touch the thumb with the index finger, then the middle finger, '
        'ring finger and little finger. Then go back in reverse order. '
        'Do 5 to 10 cycles.',
  ),

  Exercise(
    id: 'ex_short_reading',
    name: 'Short reading',
    description:
        'Read a short paragraph out loud at a comfortable pace.',
  ),

  Exercise(
    id: 'ex_hand_knee_tapping',
    name: 'Hand-to-knee tapping',
    description:
        'You can sit or stand. Touch your left knee with your right hand, '
        'then your right knee with your left hand. '
        'Alternate 10 to 20 times at a comfortable speed.',
  ),

  Exercise(
    id: 'ex_knee_lifts',
    name: 'Knee lifts',
    description:
        'Stand up and lift one knee at a time to hip height. '
        'Use a chair or wall for support if needed. '
        'Repeat 5 to 10 times per leg.',
  ),
];