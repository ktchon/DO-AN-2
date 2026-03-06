import 'dart:io';

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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<void> main() async {
  GoogleFonts.config.allowRuntimeFetching = false;

  // Liên kết Widget
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // GetX Local Storage
  await GetStorage.init();

  // Màn hình chờ hiển thị cho đến khi các mục khác load xong
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Khởi tạo Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((_) {
    // Xác định host cho emulator (rất quan trọng!)
    final String emulatorHost = Platform.isAndroid ? '10.0.2.2' : 'localhost';
    // Kết nối với Firebase Emulator
    FirebaseFirestore.instance.useFirestoreEmulator(emulatorHost, 8080);
    FirebaseAuth.instance.useAuthEmulator(emulatorHost, 9099);
    FirebaseStorage.instance.useStorageEmulator(emulatorHost, 9199);

    // Đăng ký repository
    Get.put(AuthenticationRepository());
  });

  runApp(const MyApp());
}
