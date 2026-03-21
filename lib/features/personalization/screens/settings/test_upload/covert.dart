import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';

Future<void> migrateProductSearchNames() async {
  final firestore = FirebaseFirestore.instance;
  final products = await firestore.collection('Products').get();

  WriteBatch batch = firestore.batch();

  for (var doc in products.docs) {
    String title = doc['Title'] ?? '';
    // Chuyển "Áo Thun Nam" -> "ao thun nam"
    String searchName = THelperFunctions.removeDiacritics(title).toLowerCase();

    batch.update(doc.reference, {'SearchName': searchName});
  }

  await batch.commit();
  print("Đã cập nhật SearchName cho tất cả sản phẩm!");
}
