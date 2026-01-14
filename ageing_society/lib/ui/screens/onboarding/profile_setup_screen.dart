import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  final _name = TextEditingController();
  final _yob = TextEditingController();
  final _country = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _yob.dispose();
    _country.dispose();
    super.dispose();
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('SET UP YOUR\nPROFILE',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.blue)),
                  const SizedBox(height: 18),
                  _Field(hint: 'Your name', controller: _name),
                  const SizedBox(height: 10),
                  _Field(hint: 'Year of birth', controller: _yob, keyboard: TextInputType.number),
                  const SizedBox(height: 10),
                  _Field(hint: 'Country of residence', controller: _country),
                  const SizedBox(height: 26),
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
                        context.read<AppState>().setProfile(
                              name: _name.text.trim(),
                              yob: _yob.text.trim(),
                              country: _country.text.trim(),
                            );
                        Navigator.pushNamed(context, AddSensorsScreen.route);
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

class _Field extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboard;

  const _Field({
    required this.hint,
    required this.controller,
    this.keyboard = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
