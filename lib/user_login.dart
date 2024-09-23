import 'dart:io';
import 'user_service.dart';
import 'user.dart'; // Ensure to import the User class

Future<User?> login(UserService userService) async {
  try {
    print('Enter username:');
    String username = stdin.readLineSync()!;

    // Check if the username exists in the database
    var users = await userService.fetchUserByUsername(username);
    if (users.isEmpty) {
      print('Username does not exist, please try again.');
      return null; // Return null if the username does not exist
    }

    print('Enter password: ');
    String password = stdin.readLineSync()!; // Password input without masking

    bool isAuthenticated = await userService.authenticate(username, password);
    if (isAuthenticated) {
      print('Sign in successful');
      return User.fromMap(users[0]); // Return the User object upon successful authentication
    } else {
      print('Invalid username or password');
      return null; // Return null if authentication fails
    }
  } catch (e) {
    print('Error during authentication: $e');
    return null; // Return null in case of error
  }
}
