import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/data/repositories/authentication/authentication_repository.dart';

import 'package:shop_app/firebase_options.dart';
import 'package:shop_app/utils/app.dart';

Future<void> main() async {
  GoogleFonts.config.allowRuntimeFetching = false;
  // Liên kết Widget
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // GetX Local Storage
  await GetStorage.init();
  // Màn hình chờ hiển thị cho đến khi các mục khác laod xong
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // Khởi tạo Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((_) => Get.put(AuthenticationRepository()));
  // Activate App Check
  await FirebaseAppCheck.instance.activate(
    // Cho Android: dùng debug provider khi dev/emulator
    androidProvider: AndroidProvider.debug, // <-- Đây là key để emulator hoạt động
  );
  runApp(const MyApp());
}
