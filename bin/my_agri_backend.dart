import 'dart:async';
import 'dart:io';
import 'package:my_agri_backend/buyer_dashboard.dart';

import 'package:my_agri_backend/db_service.dart';
import 'package:my_agri_backend/user_service.dart';
import 'package:my_agri_backend/user_login.dart';
import 'package:my_agri_backend/user_registration.dart';
import 'package:my_agri_backend/producer_dashboard.dart'; // Import producer dashboard

Future<void> main() async {
  var dbService = DBService();
  var userService = UserService(dbService);

  // Open database connection
  await dbService.openConnection();

  print('Choose an option: ');
  print('1. Sign up');
  print('2. Sign in');

  String choice = stdin.readLineSync()!;

  if (choice == '1') {
    await register(userService); // Call the registration function
  } else if (choice == '2') {
    var user = await login(userService); // Get the user object after login
    if (user != null) {
      if (user.role == 'producer') {
        var producerDashboard = ProducerDashboard(dbService, user);
        await producerDashboard.showMenu(); // Show producer dashboard
      } else if (user.role == 'Buyer') {
        var buyerDashboard = BuyerDashboard(dbService, user);
        await buyerDashboard.showMenu(); // Show buyer dashboard
      }
      // Add more role dashboards here (Buyers, Financial Institutions)
    }
  } else {
    print('Invalid choice. Please select 1 or 2.');
  }

  // Close database connection
  await dbService.closeConnection();
}
