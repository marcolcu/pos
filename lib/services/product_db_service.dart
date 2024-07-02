import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProductDbService {
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await init();
    return _db!;
  }

  Future<Database> init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "products.db");

    return await openDatabase(path,
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE products ("
              "id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "name TEXT, "
              "sellingPrice REAL, "
              "purchasePrice REAL, "
              "stock INTEGER"
              ")");
        }
    );
  }

  Future<int> insertProduct(String name, double sellingPrice, double purchasePrice, int stock) async {
    final db = await database;
    var values = {
      "name": name,
      "sellingPrice": sellingPrice,
      "purchasePrice": purchasePrice,
      "stock": stock,
    };
    return await db.insert("products", values);
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await database;
    return await db.query("products");
  }

  Future<Map<String, dynamic>> getProductById(int id) async {
    final db = await database;
    var result = await db.query("products", where: "id = ?", whereArgs: [id]);
    return result.first;
  }

  Future<int> updateProduct(int id, String name, double sellingPrice, double purchasePrice, int stock) async {
    final db = await database;
    var values = {
      "name": name,
      "sellingPrice": sellingPrice,
      "purchasePrice": purchasePrice,
      "stock": stock,
    };
    return await db.update("products", values, where: "id = ?", whereArgs: [id]);
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete("products", where: "id = ?", whereArgs: [id]);
  }
}
