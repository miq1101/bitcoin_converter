import 'dart:io';
import 'currensy.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  int i = 1;
  String path;
  Map<String, dynamic> countryName;
  static Database _db;

  Future<Database> get database async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    path = join(documentsDirectory.path, "TestDB5.db");
    print(path.toString() + '       aaaaaaaaaaaa');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Criptos (id SERIAL PRIMARY KEY, countryName TEXT NOT NULL UNIQUE, moneyType  TEXT NOT NULL UNIQUE, value REAL NOT NULL,flagPath TEXT NOT NULL)');
    });
  }

  insertNewCripto(Cripto newCripto) async {
    final db = await database;
    var res = await db.insert(
      'Criptos',
      newCripto.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return res;
  }

  getCriptoColumnInfo(int id, String columnName) async {
    final db = await database;
    var res = await db.query("Criptos", where: "id = ?", whereArgs: [id]);
    if (columnName == "countryName") {
      return res.isNotEmpty ? res[0]["countryName"] : Null;
    }

    if (columnName == "moneyType") {
      return res.isNotEmpty ? res[0]["moneyType"] : Null;
    }

    if (columnName == "value") {
      return res.isNotEmpty ? res[0]["value"] : Null;
    }
    if (columnName == "flagPath") {
      return res.isNotEmpty ? res[0]["flagPath"] : Null;
    }
  }

  getCriptoInfoViaId(int id) async {
    final db = await database;
    var res = await db.query("Criptos", where: "id = ?", whereArgs: [id]);

    return res.isNotEmpty ? Cripto.fromJson(res[0]) : [];
  }

  getCriptoInfoViaMoneyType(String moneyType) async {
    final db = await database;
    var res = await db
        .query("Criptos", where: "moneyType = ?", whereArgs: [moneyType]);

    return res.isNotEmpty ? Cripto.fromJson(res[0]) : [];
  }

  getAllCriptoInfo() async {
    final db = await database;
    var res = await db.query("Criptos");

    return res.isNotEmpty ? res : [];
  }

  getRawCount() async {
    final db = await database;
    int res = Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(id) from Criptos"));

    return res;
  }

  updateDB(String moneyType, Map<String, num> value) async {
    final db = await database;
    var res = await db.update("Criptos", value,
        where: "moneyType = ?", whereArgs: [moneyType]);
    return res;
  }
}
