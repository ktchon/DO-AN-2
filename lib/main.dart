import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/data/repositories/authentication/authentication_repository.dart';
import 'package:shop_app/firebase_options.dart';
import 'package:shop_app/utils/app.dart';
import 'package:shop_app/services/notification_service.dart';

import 'package:shop_app/utils/storage/storage_utility.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message: ${message.notification?.title}');
}

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

  // // Host cho emulator
  // final String emulatorHost = Platform.isAndroid ? '10.0.2.2' : 'localhost';

  // // Kết nối Firebase Emulator
  // FirebaseAuth.instance.useAuthEmulator(emulatorHost, 9099);
  // FirebaseFirestore.instance.useFirestoreEmulator(emulatorHost, 8080);
  // FirebaseStorage.instance.useStorageEmulator(emulatorHost, 9199);

  // // Disable Firestore cache khi dùng emulator (tránh bug dữ liệu)
  // FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);

  // /// 🔥 MIGRATE FIRESTORE (Emulator → Firebase thật)
  // await FirestoreMigrator.migrateAll();

  // FirebaseMessaging
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // Register Repository
  Get.put(AuthenticationRepository());
  NotificationService().init();

  // // Debug
  // debugPrint("Storage bucket: ${FirebaseStorage.instance.bucket}");
  // debugPrint("Connected emulator host: $emulatorHost");

  runApp(const MyApp());
}
