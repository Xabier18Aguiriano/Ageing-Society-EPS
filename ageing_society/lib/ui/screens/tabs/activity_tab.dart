import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/app_state.dart';
import '../../../theme/app_theme.dart';

class ActivityTab extends StatelessWidget {
  const ActivityTab({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('WEEKLY ACTIVITY', style: TextStyle(fontWeight: FontWeight.w900, color: AppTheme.blue)),
              const SizedBox(height: 6),
              const Text('Your movement this week', style: TextStyle(color: AppTheme.muted)),
              const SizedBox(height: 16),

              Container(
                height: 180,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (i) {
                    final h = (i == 3) ? 130.0 : 60.0 + (i * 10.0);
                    return Container(width: 18, height: h, decoration: BoxDecoration(color: AppTheme.blue, borderRadius: BorderRadius.circular(8)));
                  }),
                ),
              ),

              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppTheme.green.withOpacity(0.12), borderRadius: BorderRadius.circular(16)),
                child: Text('You completed ${app.weeklyMovements} movements this week!',
                    style: const TextStyle(fontWeight: FontWeight.w800, color: AppTheme.green)),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppTheme.orange.withOpacity(0.14), borderRadius: BorderRadius.circular(16)),
                child: const Text('This week you moved more than Ana! 💪',
                    style: TextStyle(fontWeight: FontWeight.w800, color: AppTheme.orange)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
