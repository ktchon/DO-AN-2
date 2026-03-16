import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

class FirestoreMigrator {
  static Future<void> migrateAll() async {
    final emulatorDb = FirebaseFirestore.instance;

    final realApp = await Firebase.initializeApp(
      name: 'real',
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final realDb = FirebaseFirestore.instanceFor(app: realApp);

    /// Root collections
    await _copySimpleCollection(emulatorDb, realDb, 'Banners');
    await _copySimpleCollection(emulatorDb, realDb, 'BrandCategory');
    await _copySimpleCollection(emulatorDb, realDb, 'Brands');
    await _copySimpleCollection(emulatorDb, realDb, 'Categories');
    await _copySimpleCollection(emulatorDb, realDb, 'Orders');
    await _copySimpleCollection(emulatorDb, realDb, 'ProductCategory');
    await _copySimpleCollection(emulatorDb, realDb, 'Products');

    /// Users (có subcollection)
    await _copyUsers(emulatorDb, realDb);

    print("✅ FULL FIRESTORE MIGRATION DONE");
  }

  /// Copy collection không có subcollection
  static Future<void> _copySimpleCollection(
    FirebaseFirestore emulatorDb,
    FirebaseFirestore realDb,
    String name,
  ) async {
    final snapshot = await emulatorDb.collection(name).get();

    for (var doc in snapshot.docs) {
      await realDb.collection(name).doc(doc.id).set(doc.data());
      print("Copied: $name/${doc.id}");
    }
  }

  /// Copy Users + subcollections
  static Future<void> _copyUsers(FirebaseFirestore emulatorDb, FirebaseFirestore realDb) async {
    final users = await emulatorDb.collection('Users').get();

    for (var user in users.docs) {
      await realDb.collection('Users').doc(user.id).set(user.data());

      print("Copied User: ${user.id}");

      /// Addresses
      final addresses = await emulatorDb
          .collection('Users')
          .doc(user.id)
          .collection('Addresses')
          .get();

      for (var addr in addresses.docs) {
        await realDb
            .collection('Users')
            .doc(user.id)
            .collection('Addresses')
            .doc(addr.id)
            .set(addr.data());

        print("Copied Address: ${addr.id}");
      }

      /// Orders
      final orders = await emulatorDb.collection('Users').doc(user.id).collection('Orders').get();

      for (var order in orders.docs) {
        await realDb
            .collection('Users')
            .doc(user.id)
            .collection('Orders')
            .doc(order.id)
            .set(order.data());

        print("Copied Order: ${order.id}");
      }
    }
  }
}
