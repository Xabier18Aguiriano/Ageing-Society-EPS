import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import '../widgets/text_field_widget.dart';
import '../services/user_service.dart';
import '../core/app_routes.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _countryCtrl.dispose();
    super.dispose();
  }

  void _continue() {
    UserService.instance.updateProfile(
      name: _nameCtrl.text,
      age: _ageCtrl.text,
      country: _countryCtrl.text,
    );
    Navigator.pushNamed(context, AppRoutes.stickers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text("Let's set up your profile", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text("Insert your personal data", style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 20),
              BigTextField(controller: _nameCtrl, label: 'Your name'),
              const SizedBox(height: 12),
              BigTextField(controller: _ageCtrl, label: 'Your age', keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              BigTextField(controller: _countryCtrl, label: 'Country of residence'),
              const SizedBox(height: 20),
              PrimaryButton(text: 'CONTINUE', onPressed: _continue),
            ],
          ),
        ),
      ),
    );
  }
}
