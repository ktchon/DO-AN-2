import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:shop_app/features/shop/models/cart_item_model.dart';

class CartRepository {
  static CartRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late final String _userId;

  CartRepository() {
    _userId = FirebaseAuth.instance.currentUser!.uid; // vì app bắt buộc login
  }

  CollectionReference<Map<String, dynamic>> get _cartCollection =>
      _db.collection('Users').doc(_userId).collection('cartItems');

  // Document ID unique cho từng cart item
  String _getDocId(CartItemModel item) {
    final variation = item.variationId?.trim() ?? '';
    if (variation.isNotEmpty) {
      return '${item.productId}_$variation';
    }
    return item.productId;
  }

  Future<void> addOrUpdateItem(CartItemModel item) async {
    final docId = _getDocId(item);
    await _cartCollection.doc(docId).set({
      ...item.toJson(),
      'addedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> removeItem(CartItemModel item) async {
    final docId = _getDocId(item);
    await _cartCollection.doc(docId).delete();
  }

  Future<void> clearAll() async {
    final snapshot = await _cartCollection.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<List<CartItemModel>> fetchAll() async {
    final snapshot = await _cartCollection.get();
    return snapshot.docs.map((doc) => CartItemModel.fromJson(doc.data())).toList();
  }
}
