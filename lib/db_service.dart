// lib/db_service.dart
import 'package:mysql1/mysql1.dart';
import 'config.dart';

class DBService {
  MySqlConnection? _connection;

  // Open a connection to the database
  Future<void> openConnection() async {
    try {
      var settings = ConnectionSettings(
        host: Config.dbHost,
        port: Config.dbPort,
        user: Config.dbUser,
        password: Config.dbPassword,
        db: Config.dbName,
      );
      _connection = await MySqlConnection.connect(settings);
      print('Database connection opened.');
    } catch (e) {
      print('Error connecting to the database: $e');
    }
  }

  // Close the database connection
  Future<void> closeConnection() async {
    if (_connection != null) {
      await _connection!.close();
    }
  }

  // Fetch all records or specific records based on conditions
  Future<List<Map<String, dynamic>>> fetch(String table, {Map<String, dynamic>? where}) async {
    if (_connection == null) return [];

    String sql = 'SELECT * FROM $table';
    List<dynamic> values = [];
    
    if (where != null && where.isNotEmpty) {
      List<String> conditions = [];
      where.forEach((key, value) {
        conditions.add('$key = ?');
        values.add(value);
      });
      sql += ' WHERE ${conditions.join(' AND ')}';
    }

    var results = await _connection!.query(sql, values);
    return results.map((row) => row.fields).toList();
  }

  // Insert a row into a table
  Future<void> insert(String table, Map<String, dynamic> values) async {
    if (_connection == null) {
      throw Exception('No database connection available.');
    }

    var columns = values.keys.join(', ');
    var placeholders = values.keys.map((_) => '?').join(', ');
    var query = 'INSERT INTO $table ($columns) VALUES ($placeholders)';
    
    await _connection!.query(query, values.values.toList());
    print('Data inserted successfully.');
  }

  // Update a row in a table
  Future<void> update(String table, Map<String, dynamic> data, {int? id, required Map where}) async {
    if (id == null) {
      throw Exception('ID must be provided for update.');
    }

    String setString = data.keys.map((key) => "$key = ?").join(", ");
    List<dynamic> values = data.values.toList()..add(id);

    String query = "UPDATE $table SET $setString WHERE id = ?";
    await _executeQuery(query, values);
  }

  // Delete a row from a table
  Future<void> delete(String table, String productId, {int? id, required Map<String, String> where}) async {
    if (id == null) {
      throw Exception('ID must be provided for deletion.');
    }

    String query = "DELETE FROM $table WHERE id = ?";
    await _executeQuery(query, [id]);
  }

  // Execute a database query
  Future<void> _executeQuery(String query, List<dynamic> values) async {
    if (_connection == null) {
      throw Exception('No database connection available.');
    }
    await _connection!.query(query, values);
  }
}
