import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class OrderDbService {
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await init();
    return _db!;
  }

  Future<Database> init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "orders.db");

    return await openDatabase(path,
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE orders ("
              "id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "product TEXT, "
              "quantity INTEGER, "
              "memberName TEXT, "
              "totalPrice REAL"
              ")");
        }
    );
  }

  Future<int> insertOrder(String product, int quantity, String? memberName, double totalPrice) async {
    final db = await database;
    var values = {
      "product": product,
      "quantity": quantity,
      "memberName": memberName,
      "totalPrice": totalPrice,
    };
    return await db.insert("orders", values);
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    final db = await database;
    return await db.query("orders");
  }

  Future<Map<String, dynamic>> getOrderById(int id) async {
    final db = await database;
    var result = await db.query("orders", where: "id = ?", whereArgs: [id]);
    return result.first;
  }

  Future<int> updateOrder(int id, String product, int quantity, String? memberName, double totalPrice) async {
    final db = await database;
    var values = {
      "product": product,
      "quantity": quantity,
      "memberName": memberName,
      "totalPrice": totalPrice,
    };
    return await db.update("orders", values, where: "id = ?", whereArgs: [id]);
  }

  Future<int> deleteOrder(int id) async {
    final db = await database;
    return await db.delete("orders", where: "id = ?", whereArgs: [id]);
  }
}
