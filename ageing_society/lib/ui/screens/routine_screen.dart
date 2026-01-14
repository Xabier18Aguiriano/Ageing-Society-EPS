import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  int step = 0;
  final steps = [
    'Stand up slowly',
    'Raise arms',
    'Walk in place for 30s',
    'Sit down slowly',
  ];

  void next() {
    if (step < steps.length - 1) {
      setState(() => step++);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Routine finished')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mini Routine')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(steps[step], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const Spacer(),
              PrimaryButton(text: step < steps.length - 1 ? 'Next' : 'Finish', onPressed: next),
            ],
          ),
        ),
      ),
    );
  }
}
