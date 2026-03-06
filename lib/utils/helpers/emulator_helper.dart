import 'dart:io';

import 'package:flutter/foundation.dart' show kDebugMode;

/// Fix download URL từ Firebase Storage Emulator cho Android Emulator.
/// Emulator trả về URL với 127.0.0.1 hoặc localhost → thay bằng 10.0.2.2 để kết nối được.
/// Chỉ áp dụng trong debug mode, production giữ nguyên URL thật.
String fixEmulatorImageUrl(String url) {
  if (!kDebugMode) {
    return url; // Production: dùng Firebase thật, không thay đổi
  }

  if (Platform.isAndroid) {
    return url.replaceAll('127.0.0.1', '10.0.2.2').replaceAll('localhost', '10.0.2.2');
  }

  // iOS Simulator / Web / Windows / macOS thường dùng localhost ok → không cần thay
  return url;
}
