import 'package:flutter/material.dart';
import '../models/sensor.dart';

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

  void addSensorMock() {
    // Simulate adding a new sensor
    final id = 'sensor_${DateTime.now().millisecondsSinceEpoch}';
    sensors.add(Sensor(id: id, name: 'New sensor', connected: true, active: false));
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
