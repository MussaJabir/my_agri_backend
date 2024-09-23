class User {
  final String username;
  final String password;
  final String email;
  final String role;
  final String id;

  User(
      {required this.username,
      required this.password,
      required this.email,
      required this.role,
      required this.id});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'],
      password: map['password'],
      email: map['email'],
      role: map['role'],
      id: map['id'],
      );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'email': email,
      'role': role,
      'id': id,
    };
  }
}
