import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static const databaseName = 'user_database.db';
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  Future<Database?> get database async {
    if (_database == null) {
      return await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), databaseName),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, email TEXT, password TEXT, cnfpass TEXT)");
    });
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db!.insert(
      "users",
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<User?> getUser(String email, String password) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db!.query("users",
        where: 'email = ? and password = ?', whereArgs: [email, password]);
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<User?> getEmail(String email) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db!.query("users",
        columns: ["email"], where: 'email = ?', whereArgs: [email]);
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? password;
  String? cnfpass;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.cnfpass,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'cnfpass': cnfpass,
    };
  }

  User.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    name = map["name"];
    email = map["email"];
    password = map["password"];
    cnfpass = map["cnfpass"];
  }
}
