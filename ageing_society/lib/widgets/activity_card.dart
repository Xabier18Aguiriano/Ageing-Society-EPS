import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class ActivityCard extends StatelessWidget {
  final int movements;

  const ActivityCard({required this.movements, super.key});

  @override
  Widget build(BuildContext context) {
    final progress = (movements % 10) / 10.0;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 8, offset: Offset(0,4))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("$movements movements completed", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: progress, minHeight: 8, backgroundColor: Colors.grey[200]),
            ]),
          ),
          const SizedBox(width: 14),
          Icon(Icons.fitness_center, size: 34, color: AppColors.accent),
        ],
      ),
    );
  }
}
