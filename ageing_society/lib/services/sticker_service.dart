import '../models/sticker.dart';

class StickerService {
  StickerService._();
  static final StickerService instance = StickerService._();

  final List<Sticker> stickers = [
    Sticker(id: 'kitchen', label: 'Kitchen sticker'),
    Sticker(id: 'bedroom', label: 'Bedroom sticker'),
  ];

  void connect(String id) {
    final s = stickers.firstWhere((e) => e.id == id, orElse: () => throw Exception('Sticker not found'));
    s.connected = true;
  }

  void disconnect(String id) {
    final s = stickers.firstWhere((e) => e.id == id, orElse: () => throw Exception('Sticker not found'));
    s.connected = false;
  }

  void toggle(String id) {
    final s = stickers.firstWhere((e) => e.id == id, orElse: () => throw Exception('Sticker not found'));
    s.connected = !s.connected;
  }
}
