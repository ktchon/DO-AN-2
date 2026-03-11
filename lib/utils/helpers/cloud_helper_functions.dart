import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CloudHelperFunctions {
  /// Hàm hỗ trợ để kiểm tra trạng thái của một bản ghi cơ sở dữ liệu duy nhất.
  ///
  /// Trả về một Widget dựa trên trạng thái của snapshot.
  /// Nếu dữ liệu vẫn đang tải, nó trả về CircularProgressIndicator.
  /// Nếu không tìm thấy dữ liệu, nó trả về thông báo "No Data Found".
  /// Nếu xảy ra lỗi, nó trả về thông báo lỗi chung.
  /// Ngược lại, nó trả về null.
  static Widget? checkSingleRecordState<T>(AsyncSnapshot<T> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data == null) {
      return const Center(child: Text('No Data Found!'));
    }

    if (snapshot.hasError) {
      return const Center(child: Text('Something went wrong.'));
    }

    return null;
  }

  /// Hàm hỗ trợ để kiểm tra trạng thái của nhiều bản ghi (dạng danh sách).
  static Widget? checkMultiRecordState<T>({
    required AsyncSnapshot<List<T>> snapshot,
    Widget? loader,
    Widget? error,
    Widget? nothingFound,
  }) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      if (loader != null) return loader;
      return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
      if (nothingFound != null) return nothingFound;
      return const Center(child: Text('Không tìm thấy dữ liệu'));
    }

    if (snapshot.hasError) {
      if (error != null) return error;
      return const Center(child: Text('Something went wrong.'));
    }

    return null;
  }

  /// Tạo một tham chiếu với đường dẫn và tên tệp ban đầu và lấy URL tải xuống.
  static Future<String> getURLFromFilePathAndName(String path) async {
    try {
      if (path.isEmpty) return '';
      final ref = FirebaseStorage.instance.ref().child(path);
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      throw e.message!;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something went wrong.';
    }
  }
}
