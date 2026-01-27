import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../theme/app_theme.dart';
import '../../../state/app_state.dart';
import 'add_sensors_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  static const route = '/profile';
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _yob = TextEditingController();
  String? _country;

  @override
  void initState() {
    super.initState();
    // Cargar datos existentes de AppState
    final app = context.read<AppState>();
    _name.text = app.name;
    _yob.text = app.yearOfBirth;
    _country = app.country.isNotEmpty ? app.country : null;
  }

  @override
  void dispose() {
    _name.dispose();
    _yob.dispose();
    super.dispose();
  }

  // Función para guardar en SharedPreferences (opcional)
  Future<void> _saveProfileToPrefs(
      String name, String yob, String country) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', name);
    await prefs.setString('profile_yob', yob);
    await prefs.setString('profile_country', country);
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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'SET UP YOUR\nPROFILE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.blue,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Nombre
                    _Field(
                      hint: 'Your name',
                      helper: 'Only letters are allowed',
                      controller: _name,
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

                    const SizedBox(height: 10),

                    // Año de nacimiento
                    _Field(
                      hint: 'Birth year',
                      helper: 'Enter a valid 4-digit year',
                      controller: _yob,
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

                    const SizedBox(height: 10),

                    // País
                    DropdownButtonFormField<String>(
                      value: _country,
                      decoration: InputDecoration(
                        hintText: 'Country of residence',
                        helperText: 'Select your country',
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
                        DropdownMenuItem(value: 'Spain', child: Text('Spain')),
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
                    ),

                    const SizedBox(height: 26),

                    // Botón CONTINUE
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please complete all fields correctly'),
                              ),
                            );
                            return;
                          }

                          // Guardar en AppState
                          context.read<AppState>().setProfile(
                                name: _name.text.trim(),
                                yob: _yob.text.trim(),
                                country: _country!,
                              );

                          // Guardar en SharedPreferences (opcional)
                          await _saveProfileToPrefs(
                              _name.text.trim(), _yob.text.trim(), _country!);

                          // Navegar a la siguiente pantalla
                          Navigator.pushNamed(context, AddSensorsScreen.route);
                        },
                        child: const Text(
                          'CONTINUE',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800),
                        ),
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
}

// Campo de formulario reutilizable
class _Field extends StatelessWidget {
  final String hint;
  final String helper;
  final TextEditingController controller;
  final TextInputType keyboard;
  final String? Function(String?)? validator;

  const _Field({
    required this.hint,
    required this.helper,
    required this.controller,
    this.keyboard = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        helperText: helper,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}