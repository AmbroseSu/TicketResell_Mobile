import 'package:shared_preferences/shared_preferences.dart';

class UserManager {
  static final UserManager _instance = UserManager._internal();

  int? _id;
  String? _email;
  int? _role;
  String? _token;
  String? _fullname;

  factory UserManager() {
    return _instance;
  }

  UserManager._internal();

  // Getter and Setter for ID
  int? get id => _id;

  set id(int? id) {
    _id = id;
    _saveToPrefs('id', id);
  }

  // Getter and Setter for Email
  String? get email => _email;

  set email(String? email) {
    _email = email;
    _saveToPrefs('email', email);
  }

  // Getter and Setter for Role
  int? get role => _role;

  set role(dynamic role) {
    _role = _convertRoleToInt(role);
    _saveToPrefs('role', _role);
  }

  String? get token => _token;

  set token(String? token){
    _token = token;
    _saveToPrefs('token', token);
  }

  String? get fullname => _fullname;

  set fullname(String? fullname){
    _fullname = fullname;
    _saveToPrefs('fullname', fullname);
  }

  Future<void> _saveToPrefs(String key, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is String) {
      prefs.setString(key, value);
    } else if (value is int) {
      prefs.setInt(key, value);
    }
  }

  Future<void> loadFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _id = prefs.getInt('id');
    _email = prefs.getString('email');
    _role = prefs.getInt('role');
    _token = prefs.getString('token');
    _fullname = prefs.getString('fullname');
  }

  Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _id = null;
    _email = null;
    _role = null;
    _token = null;
    _fullname = null;
  }

  int _convertRoleToInt(dynamic role) {
    if (role is String) {
      switch (role) {
        case 'CUSTOMER':
          return 0;
        case 'ADMIN':
          return 1;
        case 'STAFF':
          return 2;
        default:
          return -1; // Unknown role
      }
    } else if (role is int) {
      return role;
    } else {
      return -1; // Invalid role type
    }
  }
}