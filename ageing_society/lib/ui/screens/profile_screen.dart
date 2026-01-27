import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../theme/app_theme.dart';
import '../../../state/app_state.dart';

class ProfileScreen extends StatefulWidget {
  static const route = '/profile_screen';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _name;
  late TextEditingController _yob;
  String? _country;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final app = context.read<AppState>();
    _name = TextEditingController(text: app.name);
    _yob = TextEditingController(text: app.yearOfBirth);
    _country = app.country.isNotEmpty ? app.country : null;
  }

  @override
  void dispose() {
    _name.dispose();
    _yob.dispose();
    super.dispose();
  }

  Future<void> _saveProfileToPrefs(
      String name, String yob, String country) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', name);
    await prefs.setString('profile_yob', yob);
    await prefs.setString('profile_country', country);
  }

  void _cancelEdit() {
    final app = context.read<AppState>();
    setState(() {
      _name.text = app.name;
      _yob.text = app.yearOfBirth;
      _country = app.country.isNotEmpty ? app.country : null;
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Fila superior con flecha de back
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded,
                              color: AppTheme.blue, size: 28),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Icono de lápiz
                    Icon(Icons.edit, size: 50, color: AppTheme.blue),
                    const SizedBox(height: 12),

                    // Título
                    const Text(
                      'PROFILE',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.blue,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Subtítulo
                    const Text(
                      'Here you can edit your personal data',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.muted,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildField(
                            label: 'Name',
                            controller: _name,
                            enabled: _isEditing,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Name is required';
                              }
                              if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                                return 'Only letters are allowed';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),

                          _buildField(
                            label: 'Birth year',
                            controller: _yob,
                            enabled: _isEditing,
                            keyboard: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Birth year is required';
                              }
                              if (!RegExp(r'^\d{4}$').hasMatch(value)) {
                                return 'Enter a valid 4-digit year';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),

                          _isEditing
                              ? DropdownButtonFormField<String>(
                                  value: _country,
                                  decoration: InputDecoration(
                                    labelText: 'Country',
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 14),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                        value: 'Poland', child: Text('Poland')),
                                    DropdownMenuItem(
                                        value: 'France', child: Text('France')),
                                    DropdownMenuItem(
                                        value: 'Spain', child: Text('Spain')),
                                    DropdownMenuItem(
                                        value: 'Portugal', child: Text('Portugal')),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _country = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Country is required';
                                    }
                                    return null;
                                  },
                                )
                              : _displayValue(label: 'Country', value: _country ?? ''),
                          const SizedBox(height: 30),

                          // Botones
                          _isEditing
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.green,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        minimumSize: const Size(120, 48),
                                      ),
                                      onPressed: () async {
                                        if (!_formKey.currentState!.validate())
                                          return;

                                        final app = context.read<AppState>();
                                        app.setProfile(
                                            name: _name.text.trim(),
                                            yob: _yob.text.trim(),
                                            country: _country!);

                                        await _saveProfileToPrefs(_name.text.trim(),
                                            _yob.text.trim(), _country!);

                                        setState(() => _isEditing = false);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text('Profile updated!')));
                                      },
                                      child: const Text('SAVE'),
                                    ),
                                    const SizedBox(width: 16),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey[300],
                                        foregroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        minimumSize: const Size(120, 48),
                                      ),
                                      onPressed: _cancelEdit,
                                      child: const Text('CANCEL'),
                                    ),
                                  ],
                                )
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.blue,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)),
                                    minimumSize: const Size(200, 48),
                                  ),
                                  onPressed: () {
                                    setState(() => _isEditing = true);
                                  },
                                  child: const Text('EDIT'),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    bool enabled = false,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return enabled
        ? TextFormField(
            controller: controller,
            keyboardType: keyboard,
            validator: validator,
            decoration: InputDecoration(
              labelText: label,
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          )
        : _displayValue(label: label, value: controller.text);
  }

  Widget _displayValue({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, color: Colors.grey)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
