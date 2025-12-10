import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import '../widgets/sticker_card.dart';
import '../services/mock_nfc_service.dart';
import '../services/sticker_service.dart';
import '../core/app_routes.dart';

class StickersScreen extends StatefulWidget {
  const StickersScreen({super.key});

  @override
  State<StickersScreen> createState() => _StickersScreenState();
}

class _StickersScreenState extends State<StickersScreen> {
  bool scanning = false;
  String status = 'Tap "Scan sticker" to connect';

  Future<void> _scan() async {
    setState(() {
      scanning = true;
      status = 'Listening for sticker...';
    });

    try {
      final id = await MockNfcService.instance.scanTag();
      StickerService.instance.connect(id);
      setState(() {
        status = 'Connected: $id';
      });
    } catch (e) {
      setState(() {
        status = 'Scan failed';
      });
    } finally {
      await Future.delayed(const Duration(milliseconds: 400));
      setState(() => scanning = false);
    }
  }

  void _toggle(String id) {
    StickerService.instance.toggle(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final stickers = StickerService.instance.stickers;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text('Add your stickers', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('Place your phone near a sticker to connect it.', style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 18),
              PrimaryButton(text: scanning ? 'Scanning...' : 'Scan sticker', onPressed: scanning ? () {} : _scan),
              const SizedBox(height: 18),
              Expanded(
                child: ListView.separated(
                  itemCount: stickers.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final s = stickers[index];
                    return StickerCard(sticker: s, onToggle: () => _toggle(s.id));
                  },
                ),
              ),
              PrimaryButton(text: 'CONTINUE', onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.home)),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
