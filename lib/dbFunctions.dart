import 'dart:convert';
import 'dart:io';
import 'currensy.dart';
import 'package:http/http.dart';
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
    await makeGetRequestForCurrencyName();
    return _db;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    path = join(documentsDirectory.path, "TestDB4.db");
    print(path.toString() + '       aaaaaaaaaaaa');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(
              'CREATE TABLE Criptos (id SERIAL PRIMARY KEY, countryName TEXT NOT NULL UNIQUE, moneyType  TEXT NOT NULL UNIQUE, value REAL NOT NULL)');
        });
  }

  createMapforInsert(int id, String moneyType) {
    return {
      "id": id,
      "moneyType": moneyType,
    };
  }

  createMapforUpdate(num value) {
    return {
      "value": value,
    };
  }

  newCripto(Cripto newCripto) async {
    final db = await database;
    var res = await db.insert(
      'Criptos',
      newCripto.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return res;
  }

  getCriptoInfo(int id, String columnName) async {
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
  }

  getAllCripto() async {
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

  updateCripto(String moneyType, Map<String, num> value) async {
    final db = await database;
    var res = await db.update("Criptos", value,
        where: "moneyType = ?", whereArgs: [moneyType]);
    return res;
  }

  deleteCripto(double id) async {
    final db = await database;
    db.delete("Criptos", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Criptos");
  }

  makeGetRequestForUpdateCall(List list) async {
    String currencyCode = '';
    int count = list.length;
    for (int i = 0; i < count; i++) {
      currencyCode = currencyCode + list[i] + ',';
    }
    currencyCode = currencyCode.substring(0, currencyCode.length - 1);
    await makeGetRequestForUpdate(currencyCode);
  }

  makeGetRequestForUpdate(String currencyCode) async {
    String apiKey =
        'api_key=775ee409575020e8186ebd2339869437c62b648c06bd63d2baf2e8f794bebe00';
    String url =
        'https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=${currencyCode}&${apiKey}';
    Response response = await get(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> decoded = json.decode(response.body);
      await updateAllCriptoInfo(decoded);
    } else {
      throw Exception(response.statusCode);
    }
  }

  makeGetRequestCurrencyInfo(String currencyCode) async {
    String apiKey =
        'api_key=775ee409575020e8186ebd2339869437c62b648c06bd63d2baf2e8f794bebe00';
    String url =
        'https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=${currencyCode}&${apiKey}';
    Response response = await get(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> decoded = json.decode(response.body);
      await insertDBAllTables(decoded);
    } else {
      throw Exception(response.statusCode);
    }
  }

  makeGetRequestForCurrencyName() async {
    String url = 'https://openexchangerates.org/api/currencies.json';
    Response response = await get(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> decoded = json.decode(response.body);
      countryName = decoded;
      await makeGetRequestCurrencyInfoCall(decoded);
    } else {
      throw Exception(response.statusCode);
    }
  }

  makeGetRequestCurrencyInfoCall(Map<String, dynamic> decoded) async {
    List allCurrencyNames = [];
    String currencyCode = '';
    String currencyCode1 = '';

    for (var currencyName in decoded.keys) {
      allCurrencyNames.add(currencyName);
    }
    int count = allCurrencyNames.length;
    for (int i = 0; i < (count ~/ 2); i++) {
      currencyCode = currencyCode + allCurrencyNames[i] + ',';
    }
    currencyCode = currencyCode.substring(0, currencyCode.length - 1);
    await makeGetRequestCurrencyInfo(currencyCode);
    for (int i = (count ~/ 2) + (count % 2); i < count; i++) {
      currencyCode1 = currencyCode1 + allCurrencyNames[i] + ',';
    }
    currencyCode1 = currencyCode1.substring(0, currencyCode1.length - 1);

    await makeGetRequestCurrencyInfo(currencyCode1);
  }

  insertDBAllTables(Map<String, dynamic> decoded) async {
    List allCurrencyNames = [];
    for (var currencyName in decoded.keys) {
      allCurrencyNames.add(currencyName);
    }
    for (String everyCurrency in allCurrencyNames) {
      // print(decoded[everyCurrency]);
      Cripto criptoCurrency = Cripto(
          id: i,
          countryName: countryName[everyCurrency],
          moneyType: everyCurrency,
          value: decoded[everyCurrency]);
      await newCripto(criptoCurrency);
      i++;
    }
  }

  updateAllCriptoInfo(Map<String, dynamic> decoded) async {
    for (String everyCurrency in decoded.keys) {
      updateCripto(everyCurrency, createMapforUpdate(decoded[everyCurrency]));
    }
  }
}
