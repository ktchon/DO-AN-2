import 'package:intl/intl.dart';
import 'package:shop_app/utils/constants/text_string.dart';


/// LỚP KIỂM TRA HỢP LỆ (VALIDATION)
class CValidator {
  /// Kiểm tra trường rỗng
  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName là bắt buộc.';
    }

    return null;
  }

  static String? validatePinCode(String? pinCode) {
    if (pinCode == null || pinCode.isEmpty) {
      return 'Mã PIN là bắt buộc.';
    }

    // Kiểm tra độ dài tối thiểu của mã PIN
    if (pinCode.length < 6) {
      return 'Mã PIN phải có đúng 6 chữ số.';
    }

    return null;
  }

  static String? validateAge(String? input) {
    if (input == null || input.isEmpty) {
      return 'Ngày sinh là bắt buộc.';
    }

    try {
      // Phân tích ngày nhập vào định dạng 'dd-MMM-yyyy'
      final DateFormat format = DateFormat('dd-MMM-yyyy');
      final DateTime dateOfBirth = format.parse(input);

      final DateTime today = DateTime.now();
      final int age =
          today.year - dateOfBirth.year - ((today.month < dateOfBirth.month || (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) ? 1 : 0);

      if (age < 18) {
        return CTexts.dateOfBirthError;  // giữ nguyên vì đây là biến hằng số từ file text_strings
      }
    } catch (e) {
      return 'Định dạng ngày không hợp lệ. Vui lòng dùng dd-MMM-yyyy.';
    }

    return null;
  }

  /// Kiểm tra tên đăng nhập (Username)
  static String? validateUsername(String? username) {
    if (username == null || username.isEmpty) {
      return 'Tên đăng nhập là bắt buộc.';
    }

    // Mẫu regex cho tên đăng nhập hợp lệ
    const pattern = r"^[a-zA-Z0-9_-]{3,20}$";

    // Tạo đối tượng RegExp từ mẫu
    final regex = RegExp(pattern);

    // Kiểm tra xem tên đăng nhập có khớp với mẫu không
    bool isValid = regex.hasMatch(username);

    // Không được bắt đầu hoặc kết thúc bằng dấu _ hoặc -
    if (isValid) {
      isValid = !username.startsWith('_') && !username.startsWith('-') && !username.endsWith('_') && !username.endsWith('-');
    }

    if (!isValid) {
      return 'Tên đăng nhập không hợp lệ.';
    }

    return null;
  }

  /// Kiểm tra email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email là bắt buộc.';
    }

    // Biểu thức chính quy kiểm tra email
    final emailRegExp = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Địa chỉ email không hợp lệ.';
    }

    return null;
  }

  /// Kiểm tra mật khẩu
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mật khẩu là bắt buộc.';
    }

    // Kiểm tra độ dài tối thiểu
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự.';
    }

    // Kiểm tra có chữ cái in hoa
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Mật khẩu phải chứa ít nhất một chữ cái in hoa.';
    }

    // Kiểm tra có số
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Mật khẩu phải chứa ít nhất một chữ số.';
    }

    // Kiểm tra có ký tự đặc biệt
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Mật khẩu phải chứa ít nhất một ký tự đặc biệt.';
    }

    return null;
  }

  /// Kiểm tra số điện thoại
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Số điện thoại là bắt buộc.';
    }

    final returnValue = validatePhoneNumberFormat(value);

    return returnValue;
  }

  static String? validatePhoneNumberFormat(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    // Biểu thức chính quy kiểm tra số điện thoại (định dạng 10 số - kiểu Mỹ)
    final phoneRegExp = RegExp(r'^\d{10}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Định dạng số điện thoại không hợp lệ (cần đúng 10 chữ số).';
    }

    return null;
  }

  // Có thể thêm các hàm kiểm tra tùy chỉnh khác tùy theo nhu cầu ứng dụng
}