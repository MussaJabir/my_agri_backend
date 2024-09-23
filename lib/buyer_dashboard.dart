// lib/buyer_dashboard.dart
import 'dart:io';
import 'db_service.dart';
import 'user.dart';

class BuyerDashboard {
  final DBService dbService;
  final User user;

  BuyerDashboard(this.dbService, this.user);

  Future<void> showMenu() async {
    while (true) {
      print('1. Browse Products');
      print('2. Log out');

      String choice = stdin.readLineSync()!;

      if (choice == '1') {
        await browseProducts();
      } else if (choice == '2') {
        print('Logged out.');
        break;
      } else {
        print('Invalid choice. Try again.');
      }
    }
  }

  Future<void> browseProducts() async {
    try {
      var products = await dbService.fetch('producers');

      if (products.isEmpty) {
        print('No products available.');
        return;
      }

      print('Available products:');
      for (var product in products) {
        print('Product Name: ${product['product_name']}');
        print('Quantity: ${product['quantity']}');
        print('Price: ${product['price']}');
        print('Production Date: ${product['production_date']}');
        print('Description: ${product['description'] ?? 'No description'}');
        print('Status: ${product['status']}');
        print('---');
      }
    } catch (e) {
      print('Error browsing products: $e');
    }
  }
}
