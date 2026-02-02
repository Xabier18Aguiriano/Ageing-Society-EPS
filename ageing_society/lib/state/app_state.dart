import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/sensor.dart';
import '../models/exercise.dart';
import '../models/family_contact.dart';

class AppState extends ChangeNotifier {
  // --------------------------
  // Profile
  // --------------------------
  String name = '';
  String yearOfBirth = '';
  String country = '';

  // --------------------------
  // Sensors
  // --------------------------
  final List<Sensor> sensors = [
    Sensor(id: 'kitchen', name: 'Kitchen sensor', connected: true, active: true),
    Sensor(id: 'bedroom', name: 'Bedroom sensor', connected: true, active: false),
  ];

  // --------------------------
  // Activity counters
  // --------------------------
  int todayExercises = 0;
  Map<int, int> dailyMovements = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0};

  // --------------------------
  // Exercise flow
  // --------------------------
  Exercise? currentExercise;
  Exercise? _lastExercise;

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
    saveProfile();
  }

  void addSensorMock({required String name}) {
    final id = 'sensor_${DateTime.now().millisecondsSinceEpoch}';
    sensors.add(Sensor(id: id, name: name, connected: true, active: false));
    notifyListeners();
    saveSensors();
  }

  List<Sensor> get activeSensors => sensors.where((s) => s.active && s.connected).toList();

  void toggleConnect(String id) {
    final s = sensors.firstWhere((x) => x.id == id);
    s.connected = !s.connected;
    if (!s.connected) s.active = false;
    notifyListeners();
    saveSensors();
  }

  void deleteSensor(String id) {
    sensors.removeWhere((x) => x.id == id);
    notifyListeners();
    saveSensors();
  }

  void toggleActiveSensor(String id) {
    final s = sensors.firstWhere((x) => x.id == id);
    if (!s.connected) return;
    s.active = !s.active;
    notifyListeners();
    saveSensors();
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
      todayExercises++;
      addMovementToday();
      addFamilyMessagesForRoutine();
    }
    notifyListeners();
    saveProfile();
    saveActivity();
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
  void addMovementToday() {
    final today = DateTime.now().weekday - 1; // 0 = lunes
    dailyMovements[today] = (dailyMovements[today] ?? 0) + 1;
    notifyListeners();
    saveActivity();
  }

  int get weeklyMovements => dailyMovements.values.fold(0, (sum, val) => sum + val);

  // ======================
  // FAMILY CONNECTION
  // ======================
  List<FamilyContact> familyContacts = [];

  void addFamilyContact({required String name, required String phone}) {
    familyContacts.add(FamilyContact(
        id: DateTime.now().millisecondsSinceEpoch.toString(), name: name, phone: phone));
    notifyListeners();
    saveFamilyContacts();
  }

  void removeFamilyContact(String id) {
    familyContacts.removeWhere((c) => c.id == id);
    notifyListeners();
    saveFamilyContacts();
  }

  void toggleNotifications(String id) {
    final c = familyContacts.firstWhere((c) => c.id == id);
    c.notificationsEnabled = !c.notificationsEnabled;
    notifyListeners();
    saveFamilyContacts();
  }

  // ======================
  // PERSISTENCE
  // ======================
  Future<void> saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('profile', jsonEncode({
      'name': name,
      'yearOfBirth': yearOfBirth,
      'country': country,
      'todayExercises': todayExercises,
    }));
  }

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('profile');
    if (raw != null) {
      final json = jsonDecode(raw);
      name = json['name'] ?? '';
      yearOfBirth = json['yearOfBirth'] ?? '';
      country = json['country'] ?? '';
      todayExercises = json['todayExercises'] ?? 0;
      notifyListeners();
    }
  }

  Future<void> saveSensors() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('sensors', jsonEncode(sensors.map((s) => s.toJson()).toList()));
  }

  Future<void> loadSensors() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('sensors');
    if (raw != null) {
      final list = jsonDecode(raw) as List;
      sensors.clear();
      sensors.addAll(list.map((e) => Sensor.fromJson(e)));
      notifyListeners();
    }
  }

  Future<void> saveFamilyContacts() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('familyContacts', jsonEncode(familyContacts.map((c) => c.toJson()).toList()));
  }

  Future<void> loadFamilyContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('familyContacts');
    if (raw != null) {
      final list = jsonDecode(raw) as List;
      familyContacts.clear();
      familyContacts.addAll(list.map((e) => FamilyContact.fromJson(e)));
      notifyListeners();
    }
  }

  Future<void> saveActivity() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('dailyMovements', jsonEncode(dailyMovements));
  }

  Future<void> loadActivity() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('dailyMovements');
    if (raw != null) {
      dailyMovements = Map<int, int>.from(jsonDecode(raw));
      notifyListeners();
    }
  }

  // Mensajes familiares
List<String> familyMessages = [];

void addFamilyMessagesForRoutine() {
  if (familyContacts.isEmpty) return;

  final today = DateTime.now();
  final dateString = "${today.day}/${today.month}";

  for (var c in familyContacts) {
    final message = "${c.name}, ${name} completed a routine on $dateString!";
    familyMessages.add(message);
  }

  notifyListeners();
}

  Future<void> saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
    prefs.setString('yearOfBirth', yearOfBirth);
    prefs.setString('country', country);

    prefs.setInt('todayExercises', todayExercises);

    prefs.setStringList('sensors', sensors.map((s) => jsonEncode(s.toJson())).toList());
    prefs.setStringList('familyContacts', familyContacts.map((c) => jsonEncode(c.toJson())).toList());

    prefs.setString('dailyMovements', jsonEncode(dailyMovements));
  }

  Future<void> loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name') ?? '';
    yearOfBirth = prefs.getString('yearOfBirth') ?? '';
    country = prefs.getString('country') ?? '';

    todayExercises = prefs.getInt('todayExercises') ?? 0;

    final sensorList = prefs.getStringList('sensors') ?? [];
    sensors.clear();
    for (var s in sensorList) {
      sensors.add(Sensor.fromJson(jsonDecode(s)));
    }

    final contactList = prefs.getStringList('familyContacts') ?? [];
    familyContacts.clear();
    for (var c in contactList) {
      familyContacts.add(FamilyContact.fromJson(jsonDecode(c)));
    }

    final movementsStr = prefs.getString('dailyMovements');
    if (movementsStr != null) {
      dailyMovements = Map<int,int>.from(jsonDecode(movementsStr));
    }

    notifyListeners();
  }
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
    video: 'lib/assets/videos/knee_lifts.mp4',
  ),
   Exercise(
    id: 'ex_arm_circles',
    name: 'Arm circles',
    description: 'Make small circles with straight arms. 10 circles in each direction.',
    video: 'lib/assets/videos/arms_circle.mp4',
  ),
];


