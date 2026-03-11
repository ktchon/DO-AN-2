import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/formatters/formatter.dart';

class AddressModel {
  String id;
  final String name;
  final String phoneNumber;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final DateTime? dateTime;
  bool selectedAddress;

  AddressModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.dateTime,
    this.selectedAddress = true,
  });

  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);

  static AddressModel empty() => AddressModel(
    id: '',
    name: '',
    phoneNumber: '',
    street: '',
    city: '',
    state: '',
    postalCode: '',
    country: '',
  );

  /// Chuyển đối tượng AddressModel thành Map (JSON) để lưu lên Firestore hoặc gửi API
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'PhoneNumber': phoneNumber,
      'Street': street,
      'City': city,
      'State': state,
      'PostalCode': postalCode,
      'Country': country,
      'DateTime': DateTime.now(), // Thời gian hiện tại khi tạo JSON
      'SelectedAddress': selectedAddress, // Địa chỉ được chọn (mặc định hay không)
    };
  }

  /// Factory constructor để tạo AddressModel từ một Map (thường lấy từ Firestore document.data())
  factory AddressModel.fromMap(Map<String, dynamic> data) {
    return AddressModel(
      id: data['Id'] as String? ?? '',
      name: data['Name'] as String? ?? '',
      phoneNumber: data['PhoneNumber'] as String? ?? '',
      street: data['Street'] as String? ?? '',
      city: data['City'] as String? ?? '',
      state: data['State'] as String? ?? '',
      postalCode: data['PostalCode'] as String? ?? '',
      country: data['Country'] as String? ?? '',
      selectedAddress: data['SelectedAddress'] as bool? ?? false,
      dateTime: (data['DateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Factory constructor để tạo AddressModel từ DocumentSnapshot của Firestore
  factory AddressModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>? ?? {};

    return AddressModel(
      id: snapshot.id, // Lấy document ID làm id
      name: data['Name'] as String? ?? '',
      phoneNumber: data['PhoneNumber'] as String? ?? '',
      street: data['Street'] as String? ?? '',
      city: data['City'] as String? ?? '',
      state: data['State'] as String? ?? '',
      postalCode: data['PostalCode'] as String? ?? '',
      country: data['Country'] as String? ?? '',
      selectedAddress: data['SelectedAddress'] as bool? ?? false,
      dateTime: (data['DateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return '$street, $city, $state $postalCode, $country';
  }
}
