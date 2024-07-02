import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class UserDbService {
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await init();
    return _db!;
  }

  Future<Database> init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "user.db");

    return await openDatabase(path,
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, username VARCHAR(50), password VARCHAR(255))");
        }
    );
  }

  Future<int> registerUser(String username, String password) async {
    final hashedPassword = _hashPassword(password); // Hash password
    var values = {"username": username, "password": hashedPassword};
    final db = await database;
    return await db.insert("users", values);
  }

  Future<Map<String, dynamic>?> loginUser(String username, String password) async {
    final db = await database;
    final hashedPassword = _hashPassword(password);
    List<Map<String, dynamic>> maps = await db.query("users", where: "username = ? AND password = ?", whereArgs: [username, hashedPassword]);
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  String _hashPassword(String password) {
    final salt = 'your_salt_here'; // Salt untuk mengamankan hash
    final codec = utf8;
    final key = utf8.encode(salt);
    final hmacSha256 = Hmac(sha256, key); // Create HMAC-SHA256
    final hash = hmacSha256.convert(codec.encode(password));
    return hash.toString();
  }
}
