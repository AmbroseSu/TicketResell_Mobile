class UserManager {
  static final UserManager _instance = UserManager._internal();

  int? _id;
  String? _email;
  String? _role;
  String? _token;

  factory UserManager() {
    return _instance;
  }

  UserManager._internal();

  // Getter and Setter for ID
  int? get id => _id;

  set id(int? id) {
    _id = id;
  }

  // Getter and Setter for Email
  String? get email => _email;

  set email(String? email) {
    _email = email;
  }

  // Getter and Setter for Role
  String? get role => _role;

  set role(String? role) {
    _role = role;
  }

  String? get token => _token;

  set token(String? token){
    _token = token;
  }
}