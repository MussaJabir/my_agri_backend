import 'dart:io';
import 'user_service.dart';
import 'validation.dart';

Future<void> register(UserService userService) async {
  print('Enter username:');
  String username = stdin.readLineSync()!;

  String password = '';
  for (int attempts = 0; attempts < 6; attempts++) {
    print('Enter password:');
    password = stdin.readLineSync()!;
    String? passwordError = Validation.validatePassword(password);
    
    if (passwordError == null) {
      break; // Valid password entered
    } else {
      print(passwordError);
      if (attempts == 5) {
        print('Too many invalid attempts for password. Please try again later.');
        return; // Exit if 5 attempts are made
      }
    }
  }

  String email = '';
  for (int attempts = 0; attempts < 3; attempts++) {
    print('Enter email:');
    email = stdin.readLineSync()!;
    if (Validation.validateEmail(email)) {
      break; // Valid email entered
    } else {
      print('Invalid email format. Please try again.');
      if (attempts == 2) {
        print('Too many invalid attempts for email. Please try again later.');
        return; // Exit if 3 attempts are made
      }
    }
  }

  // Prompt for role selection
  print('Select your role:');
  print('1. Producer');
  print('2. Buyer');
  print('3. Financial Institution');
  
  String roleInput = stdin.readLineSync()!;
  String role;

  // Determine the role based on user input
  switch (roleInput) {
    case '1':
      role = 'Producer';
      break;
    case '2':
      role = 'Buyer';
      break;
    case '3':
      role = 'Financial Institution';
      break;
    default:
      throw Exception('Invalid role selection.');
  }

  try {
    await userService.register(username, password, email, role);
    print('User created successfully');
  } catch (e) {
    print('Error during registration: $e');
  }
}
