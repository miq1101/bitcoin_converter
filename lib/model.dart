import 'currensy.dart';
import 'netWorking.dart';
import 'dbFunctions.dart';

class Model {
  DatabaseHelper _db;
  NetWorking _net;
  List _allCurrencyCodes = [];
  Map<String, dynamic> _allCountryNames;
  int id = 1;
  Model() {
    _db = DatabaseHelper.internal();
    _net = NetWorking();
  }
  getDB() async {
    List currencyNames = [];
    String currencyName = '';
    final dataBase = await _db.database;
    int rowCount = await _db.getRawCount();
    if (rowCount == 0) {
      await getCurrencyAndCountryName();
      return dataBase;
    }
    currencyNames = await getCurrencynamesForURL(rowCount);
    currencyName = cutListFirst(currencyNames.length, currencyNames);
    await getCriptoCurrencyInfoForUpdate(currencyName);
    currencyName = cutListSecond(currencyNames.length, currencyNames);
    await getCriptoCurrencyInfoForUpdate(currencyName);
    return dataBase;
  }

  getCurrencyAndCountryName() async {
    String currencyCode = '';
    Map<String, dynamic> currensyAndCountry =
        await _net.makeGetRequestForCurrencyName();
    for (var currencyCodes in currensyAndCountry.keys) {
      _allCurrencyCodes.add(currencyCodes);
    }
    _allCountryNames = currensyAndCountry;
    int count = _allCurrencyCodes.length;
    currencyCode = await cutListFirst(count, _allCurrencyCodes);
    await getCriptoCurrencyInfo(currencyCode);
    currencyCode = await cutListSecond(count, _allCurrencyCodes);
    await getCriptoCurrencyInfo(currencyCode);
  }

  getCriptoCurrencyInfo(String currencyCode) async {
    Map<String, dynamic> criptoCurrencyInfo =
        await _net.makeGetRequestCurrencyInfo(currencyCode);
    await insertDB(criptoCurrencyInfo);
  }

  insertDB(Map<String, dynamic> criptoCurrencyInfo) async {
    for (String everyCurrency in criptoCurrencyInfo.keys) {
      Cripto criptoCurrency = Cripto(
          id: id,
          countryName: _allCountryNames[everyCurrency],
          moneyType: everyCurrency,
          value: criptoCurrencyInfo[everyCurrency],
          flagPath: "assets/${everyCurrency}.png");
      await _db.insertNewCripto(criptoCurrency);
      id++;
    }
  }

  cutListFirst(int count, List list) {
    String currencyCode = '';
    for (int i = 0; i < (count ~/ 2); i++) {
      currencyCode = currencyCode + list[i] + ',';
    }
    currencyCode = currencyCode.substring(0, currencyCode.length - 1);
    return currencyCode;
  }

  cutListSecond(int count, List list) {
    String currencyCode = '';
    for (int i = (count ~/ 2) + (count % 2); i < count; i++) {
      currencyCode = currencyCode + list[i] + ',';
    }
    currencyCode = currencyCode.substring(0, currencyCode.length - 1);
    return currencyCode;
  }

  getCurrencynamesForURL(int count) async {
    List currencyNames = [];
    for (int i = 1; i <= count; i++) {
      currencyNames.add(await _db.getCriptoInfo(i, "moneyType"));
    }
    return currencyNames;
  }

  getCriptoCurrencyInfoForUpdate(String currencyCode) async {
    Map<String, dynamic> criptoCurrencyInfo =
        await _net.makeGetRequestCurrencyInfo(currencyCode);
    upDateDB(criptoCurrencyInfo);
  }

  createMapforUpdate(num value) {
    return {
      "value": value,
    };
  }

  upDateDB(Map<String, dynamic> criptoCurrencyInfo) async {
    for (String everyCurrency in criptoCurrencyInfo.keys) {
      await _db.updateDB(
          everyCurrency, createMapforUpdate(criptoCurrencyInfo[everyCurrency]));
    }
  }

  getCripto() async {
    return await _db.getAllCripto();
  }
}
