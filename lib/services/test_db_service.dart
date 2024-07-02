import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:android_project/item_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TestDbService {
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await init();
    return _db!;
  }

  Future<Database> init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "test.db");

    return await openDatabase(path,
        version: 1,
        onCreate: (Database db, int version) {
          db.execute("CREATE TABLE items (id INTEGER PRIMARY KEY AUTOINCREMENT, title VARCHAR(50), description VARCHAR(255))");
        }
    );
  }

  Future<int> addItem(String title, String description) async {
    var values = {"title": title, "description": description};
    final db = await database;
    return await db.insert("items", values);
  }

  Future<List<ItemModel>> getItem() async {
    try {
      final db = await database;
      List<Map<String, dynamic>> maps = await db.query("items");
      if (maps.isNotEmpty) {
        return List.generate(maps.length, (i) {
          return ItemModel(
            maps[i]['id'],
            maps[i]['title'],
            maps[i]['description'],
          );
        });
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<int> updateItem(int id, String title, String description) async {
    var values = {"title": title, "description": description};
    final db = await database;
    return await db.update("items", values, where: "id = ?", whereArgs: [id]);
  }
}
