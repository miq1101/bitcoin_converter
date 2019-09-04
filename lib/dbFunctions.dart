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

  String path;
  static Database _db;


  Future<Database> get database async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    await _insertAllCriptoInfo();
    return _db;
  }

//  Future<Database> get database async {
//    if (_database != null) return _database;
//
//    _database = await initDB();
//    return _database;
//  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    path = join(documentsDirectory.path, "TestDB1.db");
    print(path.toString() + '       aaaaaaaaaaaa');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(
              'CREATE TABLE Criptos (id SERIAL PRIMARY KEY, moneyType  TEXT NOT NULL UNIQUE, value REAL NOT NULL,flagPath TEXT NOT NULL)');
        });
  }

  createMap(num value) {
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

  getCripto(String moneyType) async {
    final db = await database;
    var res = await db
        .query("Criptos", where: "moneyType = ?", whereArgs: [moneyType]);
    return res.isNotEmpty ? res : Null;
  }

  getCriptoId(String moneyType) async {
    final db = await database;
    var res = await db
        .query("Criptos", where: "moneyType = ?", whereArgs: [moneyType]);
    return res.isNotEmpty ? res[0]['id'] : Null;
  }

  getAllCripto() async {
    final db = await database;
    var res = await db.query("Criptos");

    return res.isNotEmpty ? res : [];
  }

  updateCripto(int id, Map <String, num> value) async {
    final db = await database;
    var res = await db.update("Criptos", value,
        where: "id = ?", whereArgs: [id]);
    return res;
  }

  deleteCripto(double id) async {
    final db = await database;
    db.delete("Criptos", where: "value = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Criptos");
  }

  makeGetRequest(String currencyCode) async {
    //String currencyCode = 'USD,JPY,EUR,AMD,ARS,AUD,BRL,CAD,CNY,DKK,GEL,LTL,AED,KRW,QAR,RUD,SGD,SEK,CHF,UAH,GBP';
    String apiKey =
        'api_key=775ee409575020e8186ebd2339869437c62b648c06bd63d2baf2e8f794bebe00';
    // make GET request
    String url =
        'https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=${currencyCode}&${apiKey}';
    Response response = await get(url);
    if (response.statusCode == 200) {
      //all = MoneyType.fromJson(json.decode(response.body));
//       Map<String, dynamic> decoded = json.decode(response.body);
//       for (var colour in decoded.keys) {
//         print(colour);
//
//       }
      print(response.body);
      // return all;
    } else {
      throw Exception(response.statusCode);
    }
  }

  makeGetRequestForCurrencyName() async {
    List allCurrencyNames = [];
    String currencyCode = '';
    String currencyCode1 = '';
    String currencyCode2 = '';
    int a = 0;
    String url =
        'https://openexchangerates.org/api/currencies.json';
    Response response = await get(url);
    if (response.statusCode == 200) {
      //all = MoneyType.fromJson(json.decode(response.body));
      Map<String, dynamic> decoded = json.decode(response.body);
      for (var currencyName in decoded.keys) {
        //currencyCode =currencyCode + currencyName  + ',' ;
        allCurrencyNames.add(currencyName);
        a++;
      }

      for (int i = 0; i < (a ~/ 3); i++) {
        currencyCode = currencyCode + allCurrencyNames[i] + ',';
      }
      currencyCode = currencyCode.substring(0, currencyCode.length - 1);
      print(currencyCode + "                 111111111111111");
      await makeGetRequest(currencyCode);
      for (int i = (a ~/ 3); i < 2 * (a / ~3); i++) {
        currencyCode1 = currencyCode1 + allCurrencyNames[i] + ',';
      }
      //currencyCode1 = currencyCode1.substring(0,currencyCode1.length-1);
      print(currencyCode + "     22222222222222222222");

      await makeGetRequest(currencyCode1);
      for (int i = 2 * (a ~/ 3) + (a % 3); i < a; i++) {
        currencyCode2 = currencyCode2 + allCurrencyNames[i] + ',';
      }
      currencyCode2 = currencyCode2.substring(0, currencyCode2.length - 1);
      print(currencyCode2 + "3333333333333333333333333");

      await makeGetRequest(currencyCode2);


      print(a);
    } else {
      throw Exception(response.statusCode);
    }
  }

  _insertAllCriptoInfo() async {
  }

  updateAllCriptoInfo() async {


  }
}
