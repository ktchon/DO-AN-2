import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shop_app/data/repositories/authentication/authentication_repository.dart';
import 'package:shop_app/firebase_options.dart';
import 'package:shop_app/utils/app.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shop_app/utils/storage/storage_utility.dart';

Future<void> main() async {
  GoogleFonts.config.allowRuntimeFetching = false;

  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Local
  await CLocalStorage.init('shop_storage');

  // // Local storage
  // await GetStorage.init();

  // Splash
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Host cho emulator
  final String emulatorHost = Platform.isAndroid ? '10.0.2.2' : 'localhost';

  // Kết nối Firebase Emulator
  FirebaseAuth.instance.useAuthEmulator(emulatorHost, 9099);
  FirebaseFirestore.instance.useFirestoreEmulator(emulatorHost, 8080);
  FirebaseStorage.instance.useStorageEmulator(emulatorHost, 9199);

  // Disable Firestore cache khi dùng emulator (tránh bug dữ liệu)
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);

  // Register Repository
  Get.put(AuthenticationRepository());

  // Debug
  debugPrint("Storage bucket: ${FirebaseStorage.instance.bucket}");
  debugPrint("Connected emulator host: $emulatorHost");

  runApp(const MyApp());
}
