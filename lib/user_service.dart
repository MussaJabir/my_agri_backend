import 'dart:convert';
import 'package:crypto/crypto.dart'; // To hash passwords
import 'db_service.dart';
import 'user.dart';

class UserService {
  final DBService dbService;

  UserService(this.dbService);

  // Register a new user
  Future<void> register(String username, String password, String email, String role) async {
    // Validate input
    if (username.isEmpty || password.isEmpty || email.isEmpty || role.isEmpty) {
      throw Exception('All fields are required');
    }

    // Check if username is unique
    var existingUsers = await dbService.fetch('users', where: {'username': username});

    if (existingUsers.isNotEmpty) {
      throw Exception('Username already exists.');
    }

    String hashedPassword = _hashPassword(password);
    var user = User(username: username, password: hashedPassword, email: email, role: role, id: '');

    await dbService.insert('users', user.toMap());
  }

  Future<bool> authenticate(String username, String password) async {
    // Validate input
    if (username.isEmpty || password.isEmpty) {
      throw Exception('Username and password are required');
    }

    String hashedPassword = _hashPassword(password);
    var result = await dbService.fetch('users', where: {'username': username});

    if (result.isNotEmpty) {
      return result[0]['password'] == hashedPassword;
    }
    return false;
  }

  // New method to fetch user by username
  Future<List<Map<String, dynamic>>> fetchUserByUsername(String username) async {
    var users = await dbService.fetch('users', where: {'username': username});
    return users.map((user) {
      return {
        'username': user['username'],
        'password': user['password'],
        'email': user['email'],
        'role': user['role'],
        'id': user['id'].toString(), // Ensure id is treated as a string
      };
    }).toList();
  }

  // New method to update user details
  Future<void> updateUser(String id, Map<String, dynamic> updatedValues) async {
    await dbService.update('users', updatedValues, where: {'id': id});
  }

  // New method to delete a user
  Future<void> deleteUser(String id) async {
    await dbService.delete('users', id, where: {'id': id}); // Use the correct number of arguments
  }

  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}
