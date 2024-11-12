import 'package:shared_preferences/shared_preferences.dart';

// Kiểm tra nếu người dùng đã đăng nhập
Future<bool> isUserLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token'); // Đọc token
  return token != null && token.isNotEmpty;
}

// Lưu thông tin đăng nhập (token)
Future<void> saveLoginInfo(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('token', token); // Lưu token
}

// Đăng xuất (xóa token)
Future<void> logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('token'); // Xóa token
}
