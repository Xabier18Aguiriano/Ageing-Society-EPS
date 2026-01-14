import 'package:flutter/material.dart';
import '../widgets/activity_card.dart';
import '../widgets/primary_button.dart';
import '../widgets/message_card.dart';
import '../widgets/bottom_nav.dart';
import '../../services/sticker_service.dart';
import '../../core/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int navIndex = 1;
  int movements = 3; // demo counter

  @override
  Widget build(BuildContext context) {
    final stickers = StickerService.instance.stickers;
    return Scaffold(
      appBar: AppBar(title: const Text("Today's Activity", style: TextStyle(fontWeight: FontWeight.bold))),
      bottomNavigationBar: BottomNav(currentIndex: navIndex, onTap: (i) {
        if (i == 2) {
          Navigator.pushNamed(context, AppRoutes.settings);
          return;
        }
        setState(() => navIndex = i);
      }),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ActivityCard(movements: movements),
              const SizedBox(height: 20),
              PrimaryButton(
                text: 'Start Mini Routine',
                onPressed: () {
                  setState(() => movements++);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mini-routine started (demo)')));
                },
              ),
              const SizedBox(height: 20),
              const Text('Your stickers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              for (final s in stickers) _stickerTile(s),
              const SizedBox(height: 20),
              const Text('Family Messages', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              const MessageCard(message: "Your daughter Ana says: Great job today! 😊"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stickerTile(s) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          const Icon(Icons.home),
          const SizedBox(width: 12),
          Expanded(child: Text('${s.label}')),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            decoration: BoxDecoration(color: s.connected ? Colors.green.shade50 : Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              Icon(s.connected ? Icons.check_circle : Icons.radio_button_unchecked, color: s.connected ? Colors.green : Colors.grey),
              const SizedBox(width: 8),
              Text(s.connected ? 'Active' : 'Inactive'),
            ]),
          )
        ],
      ),
    );
  }
}
