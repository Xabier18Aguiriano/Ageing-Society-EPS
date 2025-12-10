import 'dart:async';

/// Mock NFC scanning service for emulator testing.
/// Replace with real implementation (nfc_manager) on device.
class MockNfcService {
  MockNfcService._();
  static final MockNfcService instance = MockNfcService._();

  /// Simulate scanning - returns a sticker id (e.g. 'kitchen') after delay
  Future<String> scanTag() async {
    await Future.delayed(const Duration(seconds: 1));
    // For demo return 'kitchen' — you can randomize if you want
    return 'kitchen';
  }
}
