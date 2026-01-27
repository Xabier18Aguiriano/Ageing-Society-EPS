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

  // Activity counters
  int todayExercises = 0;

  // Movimientos diarios para el gráfico (0=lunes, 6=domingo)
  Map<int, int> dailyMovements = {
    0: 0,
    1: 0,
    2: 0,
    3: 0,
    4: 0,
    5: 0,
    6: 0,
  };

  // Ejercicio actual
  Exercise? currentExercise;
  Exercise? _lastExercise;

  // Exercise flow
  void startRandomExercise() {
    if (exercises.isEmpty) return;

    final random = Random();
    Exercise selected;

    do {
      selected = exercises[random.nextInt(exercises.length)];
    } while (_lastExercise != null &&
        selected == _lastExercise &&
        exercises.length > 1);

    _lastExercise = selected;
    currentExercise = selected;
    notifyListeners();
  }

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

  List<Sensor> get activeSensors {
    return sensors.where((s) => s.active && s.connected).toList();
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

  void toggleActiveSensor(String id) {
    final s = sensors.firstWhere((x) => x.id == id);
    if (!s.connected) return;
    s.active = !s.active;
    notifyListeners();
  }

  Sensor? get activeSensor {
    try {
      return sensors.firstWhere((s) => s.active);
    } catch (_) {
      return null;
    }
  }

  // ======================
  // MINI ROUTINE LOGIC
  // ======================

  List<Sensor> routineSensors = [];
  int routineIndex = 0;

  // Start routine using 3–4 random active & connected sensors
  void startRoutine() {
    final availableSensors = sensors.where((s) => s.active && s.connected).toList();
    if (availableSensors.isEmpty) return;

    final random = Random();
    availableSensors.shuffle(random);

    final count = min(availableSensors.length, random.nextBool() ? 3 : 4);

    routineSensors = [];
    for (final sensor in availableSensors) {
      if (routineSensors.isNotEmpty && routineSensors.last.id == sensor.id) continue;
      routineSensors.add(sensor);
      if (routineSensors.length == count) break;
    }

    routineIndex = 0;
    notifyListeners();
  }

  Sensor? get currentRoutineSensor {
    if (isRoutineFinished) return null;
    return routineSensors[routineIndex];
  }

  void nextRoutineSensor() {
    routineIndex++;
    if (isRoutineFinished) {
      todayExercises++; // Incrementa ejercicios hoy
      addMovementToday(); // Sincroniza con gráfico
    }
    notifyListeners();
  }

  bool get isRoutineFinished => routineIndex >= routineSensors.length;

  void resetRoutine() {
    routineSensors.clear();
    routineIndex = 0;
    notifyListeners();
  }

  // ======================
  // MOVEMENTS BY DAY
  // ======================

  // Suma +1 al día actual
  void addMovementToday() {
    final today = DateTime.now().weekday - 1; // 0 = lunes
    dailyMovements[today] = (dailyMovements[today] ?? 0) + 1;
    notifyListeners();
  }

  // Total semanal
  int get weeklyMovements => dailyMovements.values.fold(0, (sum, val) => sum + val);
}

// ======================
// Exercises "database"
// ======================

final List<Exercise> exercises = [
  Exercise(
    id: 'ex_fist_squeezing',
    name: 'Fist squeezing',
    description: 'Close fists for 3s, release, stretch fingers. Repeat 10 times.',
    video: 'lib/assets/videos/example.mp4',
  ),
  Exercise(
    id: 'ex_finger_tapping',
    name: 'Finger tapping',
    description: 'Tap thumb with each finger in order, then reverse. 5–10 cycles.',
    video: 'lib/assets/videos/example.mp4',
  ),
  Exercise(
    id: 'ex_short_reading',
    name: 'Short reading',
    description: 'Read a short paragraph aloud at a comfortable pace.',
    video: 'lib/assets/videos/example.mp4',
  ),
  Exercise(
    id: 'ex_hand_knee_tapping',
    name: 'Hand-to-knee tapping',
    description: 'Touch left knee with right hand, alternate 10–20 times.',
    video: 'lib/assets/videos/example.mp4',
  ),
  Exercise(
    id: 'ex_knee_lifts',
    name: 'Knee lifts',
    description: 'Lift knees to hip height, 5–10 times per leg, support if needed.',
    video: 'lib/assets/videos/example.mp4',
  ),
   Exercise(
    id: 'ex_arm_circles',
    name: 'Arm circles',
    description: 'Make small circles with straight arms. 10 circles in each direction.',
    video: 'lib/assets/videos/example.mp4',
  ),
];


