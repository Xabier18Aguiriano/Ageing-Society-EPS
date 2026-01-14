import 'package:flutter/material.dart';
import '../../widgets/primary_button.dart';
import '../../../core/app_routes.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo.png', height: 180, width: 180, fit: BoxFit.contain),
                    const SizedBox(height: 28),
                    const Text('LiftUp', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF2A4B74))),
                  ],
                ),
              ),
              PrimaryButton(
                text: 'START',
                onPressed: () => Navigator.pushNamed(context, AppRoutes.setup),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}
