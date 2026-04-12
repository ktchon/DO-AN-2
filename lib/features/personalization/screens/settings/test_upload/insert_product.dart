import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/utils/popups/loaders.dart';

Future<void> insertSampleProducts() async {
  final firestore = FirebaseFirestore.instance;

  // ==================== DANH SÁCH SẢN PHẨM MỚI MUỐN THÊM ====================
  final List<Map<String, dynamic>> newProducts = [
    // =========================
    // PRODUCT 1
    // =========================
    {
      'SKU': 'AT001',
      'Title': 'Áo Thun Nam Basic',
      'Stock': 25,
      'Price': 250000,
      'SalePrice': 199000,
      'IsFeatured': true,
      'Thumbnail':
          'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Products%2FNikeBasketballShoeGreenBlack.png?alt=media&token=5f70fb29-fc68-4889-85aa-852c1da322c5',
      'CategoryId': 'fashion_men',
      'Description': 'Áo thun cotton 100%, co giãn 4 chiều',
      'ProductType': 'ProductType.single',

      'Images': [
        'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Products%2Fleather_jacket_4.png?alt=media&token=16891caa-3f2b-403d-a825-b58ebd25db5c',
        'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Products%2Fsamsung_s9_mobile.png?alt=media&token=2158b168-7d5c-4bab-8326-dc2a59a4ac7f',
      ],

      'Brand': {
        'Id': 'nike_01',
        'Name': 'Nike',
        'Image':
            'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Categorys%2Flogo-nike.png?alt=media&token=eeff4228-dfd0-4519-b884-88b72c80f140',
        'IsFeatured': true,
        'ProductsCount': 120,
      },

      'ProductAttributes': [
        {
          'Name': 'Color',
          'Values': ['Black', 'Red', 'Green'],
        },
        {
          'Name': 'Size',
          'Values': ['S', 'M', 'L'],
        },
      ],

      'ProductVariations': [
        {
          'Id': 'var1',
          'Stock': 15,
          'Price': 250000,
          'SalePrice': 199000,
          'Image':
              'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Products%2Fsamsung_s9_mobile.png?alt=media&token=2158b168-7d5c-4bab-8326-dc2a59a4ac7f',
          'AttributeValues': {'Color': 'Black', 'Size': 'M'},
        },
        {
          'Id': 'var2',
          'Stock': 10,
          'Price': 500000,
          'SalePrice': 450000,
          'Image':
              'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Products%2Fsamsung_s9_mobile.png?alt=media&token=2158b168-7d5c-4bab-8326-dc2a59a4ac7f',
          'AttributeValues': {'Color': 'Green', 'Size': 'S'},
        },
      ],
    },

    // =========================
    // PRODUCT 2
    // =========================
    {
      'SKU': 'AT002',
      'Title': 'Áo Thun Nam Premium',
      'Stock': 40,
      'Price': 300000,
      'SalePrice': 259000,
      'IsFeatured': true,
      'Thumbnail':
          'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Products%2Fleather_jacket_4.png?alt=media&token=16891caa-3f2b-403d-a825-b58ebd25db5c',
      'CategoryId': 'fashion_men',
      'Description': 'Áo thun cao cấp, chất vải mềm mịn thoáng khí',
      'ProductType': 'ProductType.single',

      'Images': [
        'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Products%2Fleather_jacket_4.png?alt=media&token=16891caa-3f2b-403d-a825-b58ebd25db5c',
        'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Products%2Fsamsung_s9_mobile.png?alt=media&token=2158b168-7d5c-4bab-8326-dc2a59a4ac7f',
      ],

      'Brand': {
        'Id': 'nike_01',
        'Name': 'Nike',
        'Image':
            'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Categorys%2Flogo-nike.png?alt=media&token=eeff4228-dfd0-4519-b884-88b72c80f140',
        'IsFeatured': true,
        'ProductsCount': 120,
      },

      'ProductAttributes': [
        {
          'Name': 'Color',
          'Values': ['Black', 'Blue'],
        },
        {
          'Name': 'Size',
          'Values': ['M', 'L', 'XL'],
        },
      ],

      'ProductVariations': [
        {
          'Id': 'var1',
          'Stock': 20,
          'Price': 300000,
          'SalePrice': 259000,
          'Image':
              'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Products%2Fleather_jacket_4.png?alt=media&token=16891caa-3f2b-403d-a825-b58ebd25db5c',
          'AttributeValues': {'Color': 'Black', 'Size': 'L'},
        },
        {
          'Id': 'var2',
          'Stock': 20,
          'Price': 320000,
          'SalePrice': 279000,
          'Image':
              'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Products%2Fleather_jacket_4.png?alt=media&token=16891caa-3f2b-403d-a825-b58ebd25db5c',
          'AttributeValues': {'Color': 'Blue', 'Size': 'XL'},
        },
      ],
    },
    // =========================
    // PRODUCT 3
    // =========================
    {
      'SKU': 'AT001',
      'Title': 'Áo Thun Nam Basic',
      'Stock': 25,
      'Price': 250000,
      'SalePrice': 199000,
      'IsFeatured': true,
      'Thumbnail':
          'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Products%2FNikeBasketballShoeGreenBlack.png?alt=media&token=5f70fb29-fc68-4889-85aa-852c1da322c5',
      'CategoryId': 'fashion_men',
      'Description': 'Áo thun cotton 100%, co giãn 4 chiều',
      'ProductType': 'ProductType.single',

      'Images': [
        'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Products%2Fleather_jacket_4.png?alt=media&token=16891caa-3f2b-403d-a825-b58ebd25db5c',
        'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Products%2Fsamsung_s9_mobile.png?alt=media&token=2158b168-7d5c-4bab-8326-dc2a59a4ac7f',
      ],

      'Brand': {
        'Id': 'nike_01',
        'Name': 'Nike',
        'Image':
            'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Categorys%2Flogo-nike.png?alt=media&token=eeff4228-dfd0-4519-b884-88b72c80f140',
        'IsFeatured': true,
        'ProductsCount': 120,
      },

      'ProductAttributes': [
        {
          'Name': 'Color',
          'Values': ['Black', 'Red', 'Green'],
        },
        {
          'Name': 'Size',
          'Values': ['S', 'M', 'L'],
        },
      ],

      'ProductVariations': [
        {
          'Id': 'var1',
          'Stock': 15,
          'Price': 250000,
          'SalePrice': 199000,
          'Image':
              'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Products%2Fsamsung_s9_mobile.png?alt=media&token=2158b168-7d5c-4bab-8326-dc2a59a4ac7f',
          'AttributeValues': {'Color': 'Black', 'Size': 'M'},
        },
        {
          'Id': 'var2',
          'Stock': 10,
          'Price': 500000,
          'SalePrice': 450000,
          'Image':
              'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Products%2Fsamsung_s9_mobile.png?alt=media&token=2158b168-7d5c-4bab-8326-dc2a59a4ac7f',
          'AttributeValues': {'Color': 'Green', 'Size': 'S'},
        },
      ],
    },
    // =========================
    // PRODUCT 4
    // =========================
    {
      'SKU': 'AT001',
      'Title': 'Áo Thun Nam Basic',
      'Stock': 25,
      'Price': 250000,
      'SalePrice': 199000,
      'IsFeatured': true,
      'Thumbnail':
          'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Products%2FNikeBasketballShoeGreenBlack.png?alt=media&token=5f70fb29-fc68-4889-85aa-852c1da322c5',
      'CategoryId': 'fashion_men',
      'Description': 'Áo thun cotton 100%, co giãn 4 chiều',
      'ProductType': 'ProductType.single',

      'Images': [
        'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Products%2Fleather_jacket_4.png?alt=media&token=16891caa-3f2b-403d-a825-b58ebd25db5c',
        'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Products%2Fsamsung_s9_mobile.png?alt=media&token=2158b168-7d5c-4bab-8326-dc2a59a4ac7f',
      ],

      'Brand': {
        'Id': 'nike_01',
        'Name': 'Nike',
        'Image':
            'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Categorys%2Flogo-nike.png?alt=media&token=eeff4228-dfd0-4519-b884-88b72c80f140',
        'IsFeatured': true,
        'ProductsCount': 120,
      },

      'ProductAttributes': [
        {
          'Name': 'Color',
          'Values': ['Black', 'Red', 'Green'],
        },
        {
          'Name': 'Size',
          'Values': ['S', 'M', 'L'],
        },
      ],

      'ProductVariations': [
        {
          'Id': 'var1',
          'Stock': 15,
          'Price': 250000,
          'SalePrice': 199000,
          'Image':
              'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Products%2Fsamsung_s9_mobile.png?alt=media&token=2158b168-7d5c-4bab-8326-dc2a59a4ac7f',
          'AttributeValues': {'Color': 'Black', 'Size': 'M'},
        },
        {
          'Id': 'var2',
          'Stock': 10,
          'Price': 500000,
          'SalePrice': 450000,
          'Image':
              'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Products%2Fsamsung_s9_mobile.png?alt=media&token=2158b168-7d5c-4bab-8326-dc2a59a4ac7f',
          'AttributeValues': {'Color': 'Green', 'Size': 'S'},
        },
      ],
    },
    // =========================
    // PRODUCT 5
    // =========================
    {
      'SKU': 'AT001',
      'Title': 'Áo Thun Nam Basic',
      'Stock': 25,
      'Price': 250000,
      'SalePrice': 199000,
      'IsFeatured': true,
      'Thumbnail':
          'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Products%2FNikeBasketballShoeGreenBlack.png?alt=media&token=5f70fb29-fc68-4889-85aa-852c1da322c5',
      'CategoryId': 'fashion_men',
      'Description': 'Áo thun cotton 100%, co giãn 4 chiều',
      'ProductType': 'ProductType.single',

      'Images': [
        'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Products%2Fleather_jacket_4.png?alt=media&token=16891caa-3f2b-403d-a825-b58ebd25db5c',
        'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Products%2Fsamsung_s9_mobile.png?alt=media&token=2158b168-7d5c-4bab-8326-dc2a59a4ac7f',
      ],

      'Brand': {
        'Id': 'nike_01',
        'Name': 'Nike',
        'Image':
            'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Categorys%2Flogo-nike.png?alt=media&token=eeff4228-dfd0-4519-b884-88b72c80f140',
        'IsFeatured': true,
        'ProductsCount': 120,
      },

      'ProductAttributes': [
        {
          'Name': 'Color',
          'Values': ['Black', 'Red', 'Green'],
        },
        {
          'Name': 'Size',
          'Values': ['S', 'M', 'L'],
        },
      ],

      'ProductVariations': [
        {
          'Id': 'var1',
          'Stock': 15,
          'Price': 250000,
          'SalePrice': 199000,
          'Image':
              'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Products%2Fsamsung_s9_mobile.png?alt=media&token=2158b168-7d5c-4bab-8326-dc2a59a4ac7f',
          'AttributeValues': {'Color': 'Black', 'Size': 'M'},
        },
        {
          'Id': 'var2',
          'Stock': 10,
          'Price': 500000,
          'SalePrice': 450000,
          'Image':
              'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Products%2Fsamsung_s9_mobile.png?alt=media&token=2158b168-7d5c-4bab-8326-dc2a59a4ac7f',
          'AttributeValues': {'Color': 'Green', 'Size': 'S'},
        },
      ],
    },
    // =========================
    // PRODUCT 6
    // =========================
    {
      'SKU': 'AT001',
      'Title': 'Áo Thun Nam Basic',
      'Stock': 25,
      'Price': 250000,
      'SalePrice': 199000,
      'IsFeatured': true,
      'Thumbnail':
          'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Products%2FNikeBasketballShoeGreenBlack.png?alt=media&token=5f70fb29-fc68-4889-85aa-852c1da322c5',
      'CategoryId': 'fashion_men',
      'Description': 'Áo thun cotton 100%, co giãn 4 chiều',
      'ProductType': 'ProductType.single',

      'Images': [
        'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Products%2Fleather_jacket_4.png?alt=media&token=16891caa-3f2b-403d-a825-b58ebd25db5c',
        'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Products%2Fsamsung_s9_mobile.png?alt=media&token=2158b168-7d5c-4bab-8326-dc2a59a4ac7f',
      ],

      'Brand': {
        'Id': 'nike_01',
        'Name': 'Nike',
        'Image':
            'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Categorys%2Flogo-nike.png?alt=media&token=eeff4228-dfd0-4519-b884-88b72c80f140',
        'IsFeatured': true,
        'ProductsCount': 120,
      },

      'ProductAttributes': [
        {
          'Name': 'Color',
          'Values': ['Black', 'Red', 'Green'],
        },
        {
          'Name': 'Size',
          'Values': ['S', 'M', 'L'],
        },
      ],

      'ProductVariations': [
        {
          'Id': 'var1',
          'Stock': 15,
          'Price': 250000,
          'SalePrice': 199000,
          'Image':
              'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Products%2Fsamsung_s9_mobile.png?alt=media&token=2158b168-7d5c-4bab-8326-dc2a59a4ac7f',
          'AttributeValues': {'Color': 'Black', 'Size': 'M'},
        },
        {
          'Id': 'var2',
          'Stock': 10,
          'Price': 500000,
          'SalePrice': 450000,
          'Image':
              'https://firebasestorage.googleapis.com/v0/b/shopapp-e5f12.firebasestorage.app/o/Products%2Fsamsung_s9_mobile.png?alt=media&token=2158b168-7d5c-4bab-8326-dc2a59a4ac7f',
          'AttributeValues': {'Color': 'Green', 'Size': 'S'},
        },
      ],
    },
  ];

  int addedCount = 0;

  try {
    // Lấy ID lớn nhất hiện tại
    final snapshot = await firestore.collection('Products').get();

    int maxId = 0;
    for (var doc in snapshot.docs) {
      final idNum = int.tryParse(doc.id) ?? 0;
      if (idNum > maxId) maxId = idNum;
    }

    int nextId = maxId + 1;

    final batch = firestore.batch();

    for (var product in newProducts) {
      final String newDocId = nextId.toString().padLeft(3, '0'); // 007, 008,...

      batch.set(firestore.collection('Products').doc(newDocId), product);

      nextId++;
      addedCount++;
    }

    if (addedCount > 0) {
      await batch.commit();

      CLoaders.successSnackBar(
        title: 'Thành công!',
        message: 'Đã thêm $addedCount sản phẩm mới.\nID tiếp theo là $nextId',
      );
    } else {
      CLoaders.warningSnackBar(title: 'Thông báo', message: 'Không có sản phẩm nào được thêm.');
    }
  } catch (e) {
    CLoaders.errorSnackBar(title: 'Lỗi!', message: 'Không thể thêm sản phẩm: $e');
  }
}
