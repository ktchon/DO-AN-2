import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/utils/popups/loaders.dart';

Future<void> insertSampleProducts() async {
  final firestore = FirebaseFirestore.instance;
  final batch = firestore.batch();

  final List<Map<String, dynamic>> products = [
    // =========================
    // PRODUCT 1 - SINGLE
    // =========================
    {
      'SKU': 'AT001',
      'Title': 'Áo Thun Nam Basic',
      'Stock': 25,
      'Price': 250000,
      'SalePrice': 199000,
      'IsFeatured': true,
      'Thumbnail': '', // <-- Upload Firebase rồi thay vào đây
      'CategoryId': 'fashion_men',
      'Description': 'Áo thun cotton 100%, co giãn 4 chiều',
      'ProductType': 'ProductType.single',
      'Images': [
        '', // <-- image 1
        '', // <-- image 2
      ],
      'Brand': {
        'Id': 'nike_01',
        'Name': 'Nike',
        'Image': '', // <-- brand image
        'IsFeatured': true,
        'ProductsCount': 120,
      },
      'ProductAttributes': [],
      'ProductVariations': [],
    },

    // =========================
    // PRODUCT 2 - VARIABLE
    // =========================
    {
      'SKU': 'AK001',
      'Title': 'Áo Khoác Hoodie Unisex',
      'Stock': 50,
      'Price': 500000,
      'SalePrice': 0,
      'IsFeatured': true,
      'Thumbnail': '', // <-- Upload rồi thay
      'CategoryId': 'fashion_unisex',
      'Description': 'Áo hoodie form rộng, chất nỉ cao cấp',
      'ProductType': 'ProductType.variable',
      'Images': [
        '', // <-- image 1
        '', // <-- image 2
      ],
      'Brand': {
        'Id': 'adidas_01',
        'Name': 'Adidas',
        'Image': '', // <-- brand image
        'IsFeatured': true,
        'ProductsCount': 200,
      },
      'ProductAttributes': [
        {
          'Name': 'Size',
          'Values': ['S', 'M', 'L'],
        },
        {
          'Name': 'Color',
          'Values': ['Black', 'White'],
        },
      ],
      'ProductVariations': [
        {
          'Id': 'var1',
          'Stock': 10,
          'Price': 500000,
          'SalePrice': 450000,
          'Image': '', // <-- variation image
          'AttributeValues': {'Size': 'S', 'Color': 'Black'},
        },
        {
          'Id': 'var2',
          'Stock': 15,
          'Price': 520000,
          'SalePrice': 470000,
          'Image': '', // <-- variation image
          'AttributeValues': {'Size': 'M', 'Color': 'White'},
        },
      ],
    },
  ];

  try {
    for (var product in products) {
      final docRef = firestore.collection('Products').doc();
      batch.set(docRef, product);
    }

    await batch.commit();

    CLoaders.successSnackBar(title: 'Thành công!', message: 'Đã thêm 2 sản phẩm mẫu vào Firestore');
  } catch (e) {
    CLoaders.errorSnackBar(title: 'Lỗi!', message: 'Không thể thêm sản phẩm: $e');
  }
}
