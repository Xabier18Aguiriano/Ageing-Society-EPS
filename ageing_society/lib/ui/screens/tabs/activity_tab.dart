import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../state/app_state.dart';
import '../../../theme/app_theme.dart';

class ActivityTab extends StatelessWidget {
  const ActivityTab({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    final List<int> weeklyMovementsPerDay = List.generate(7, (i) {
      return app.dailyMovements[i] ?? 0;
    });

    final todayIndex = DateTime.now().weekday - 1;
    const daysAbbr = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    final maxMovements = weeklyMovementsPerDay.isNotEmpty
        ? weeklyMovementsPerDay.reduce((a, b) => a > b ? a : b).toDouble()
        : 1.0;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'WEEKLY ACTIVITY',
                style: TextStyle(
                    fontWeight: FontWeight.w900, color: AppTheme.blue),
              ),
              const SizedBox(height: 6),
              const Text('Your movement this week',
                  style: TextStyle(color: AppTheme.muted)),
              const SizedBox(height: 16),

              Container(
                height: 280,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(7, (i) {
                    final value = weeklyMovementsPerDay[i].toDouble();
                    final isToday = i == todayIndex;

                    return Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Número animado de movimientos
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0, end: value),
                            duration: const Duration(milliseconds: 500),
                            builder: (context, val, _) => Text(
                              val.toInt().toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: isToday
                                      ? AppTheme.orange
                                      : AppTheme.blue),
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Barra animada
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: TweenAnimationBuilder<double>(
                                tween: Tween<double>(begin: 0, end: maxMovements > 0 ? (value / maxMovements) * 220 : 0),
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeOutCubic,
                                builder: (context, height, _) => Container(
                                  width: 18,
                                  height: height,
                                  decoration: BoxDecoration(
                                    color: isToday
                                        ? AppTheme.orange
                                        : AppTheme.blue,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Día de la semana
                          Text(
                            daysAbbr[i],
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color:
                                    isToday ? AppTheme.orange : AppTheme.muted),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: AppTheme.green.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16)),
                child: Text(
                    'You completed ${app.weeklyMovements} movements this week!',
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, color: AppTheme.green)),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: AppTheme.orange.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(16)),
                child: const Text('This week you moved more than Ana! 💪',
                    style: TextStyle(
                        fontWeight: FontWeight.w800, color: AppTheme.orange)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}