import 'package:flutter/material.dart';
import '../models/sticker.dart';

class StickerCard extends StatelessWidget {
  final Sticker sticker;
  final VoidCallback onToggle;

  const StickerCard({required this.sticker, required this.onToggle, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 8, offset: Offset(0,4))],
      ),
      child: Row(
        children: [
          const Icon(Icons.nfc, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(sticker.label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
          GestureDetector(
            onTap: onToggle,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              decoration: BoxDecoration(
                color: sticker.connected ? Colors.green.shade50 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(sticker.connected ? Icons.check_circle : Icons.radio_button_unchecked, color: sticker.connected ? Colors.green : Colors.grey),
                  const SizedBox(width: 6),
                  Text(sticker.connected ? 'Connected' : 'Not connected', style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
