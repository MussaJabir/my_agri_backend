import 'dart:io';
import 'db_service.dart';
import 'user.dart';

class ProducerDashboard {
  final DBService dbService;
  final User user;

  ProducerDashboard(this.dbService, this.user);

  // Display the dashboard menu
  Future<void> showMenu() async {
    print('Welcome, ${user.username}! You are logged in as a Producer.');
    print('1. Add Product');
    print('2. View Products');
    print('3. Update Product');
    print('4. Delete Product');
    print('5. Log out');

    String choice = stdin.readLineSync()!;

    switch (choice) {
      case '1':
        await addProduct();
        break;
      case '2':
        await viewProducts();
        break;
      case '3':
        await updateProduct();
        break;
      case '4':
        await deleteProduct();
        break;
      case '5':
        print('Logging out...');
        break;
      default:
        print('Invalid option. Please select a valid choice.');
    }
  }

  // Add a new product
  Future<void> addProduct() async {
    try {
      print('Enter product name:');
      String productName = stdin.readLineSync()!;

      print('Enter product quantity:');
      String quantity = stdin.readLineSync()!;

      print('Enter product price:');
      String price = stdin.readLineSync()!;

      print('Enter production date (YYYY-MM-DD):');
      String productionDate = stdin.readLineSync()!;

      print('Enter product status:');
      String status = stdin.readLineSync()!;

      print('Enter product description (optional):');
      String? description = stdin.readLineSync();

      // Prepare data to insert into the database
      var productData = {
        'user_id': user.id, // Assuming user ID is stored in the User object
        'product_name': productName,
        'quantity': quantity,
        'price': price,
        'production_date': productionDate,
        'status': status,
        'description':
            description ?? '', // If no description, set to an empty string
      };

      // Insert product into the database
      await dbService.insert('producers', productData);

      print('Product added successfully!');
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  // View all products added by the producer
  Future<void> viewProducts() async {
    var products =
        await dbService.fetch('producers', where: {'user_id': user.id});

    if (products.isEmpty) {
      print('No products found.');
    } else {
      print('Your Products:');
      for (var product in products) {
        print(
            'ID: ${product['id']}, Name: ${product['product_name']}, Quantity: ${product['quantity']}, Price: ${product['price']},  Production Date: ${product['production_date']}, Status: ${product['status']}');
      }
    }
  }

  // Update a product
  Future<void> updateProduct() async {
    print('Enter the product ID to update:');
    String productId = stdin.readLineSync()!;

    print('Enter the new product name:');
    String newName = stdin.readLineSync()!;

    print('Enter the new product quantity:');
    String newQuantity = stdin.readLineSync()!;

    print('Enter the new product price:');
    String newPrice = stdin.readLineSync()!;

    try {
      await dbService.update('producers', {
        'name': newName,
        'quantity': newQuantity,
        'price': newPrice,
      }, where: {
        'id': productId
      });
      print('Product updated successfully.');
    } catch (e) {
      print('Error updating product: $e');
    }
  }

  // Delete a product
  Future<void> deleteProduct() async {
    print('Enter the product ID to delete:');
    String productId = stdin.readLineSync()!;

    try {
      // Use the productId for both the ID and in the where clause
      await dbService.delete('producers', productId,
          id: int.tryParse(productId), where: {'id': productId});
      print('Product deleted successfully.');
    } catch (e) {
      print('Error deleting product: $e');
    }
  }
}
