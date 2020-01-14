import 'package:bitcoin_converter/src/database/db_provider.dart';
import 'package:bitcoin_converter/src/models/currency.dart';
import 'package:bitcoin_converter/src/models/selected_type.dart';
import 'package:bitcoin_converter/src/provider/provider.dart';
import 'package:bitcoin_converter/src/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BtcRepository {
  DatabaseHelper _db;
  BtcProvider _net;
  List _allCurrencyCodes = [];
  Map<String, dynamic> _allCountryNames;
  int id = 1;

  BtcRepository() {
    _db = BtcConstants.db;
    _net = BtcProvider();
  }

  getDB() async {
    BtcSelectedType _selectedType = BtcSelectedType();
    String topMoneyType;
    String bottomMoneyType;
    int rowCount = await _db.getRawCount();
    if (rowCount == 0) {
      bool isGetInfo = await getCurrencyAndCountryName();
      if (isGetInfo) {
        BtcSelectedType selectedType =
            BtcSelectedType(firstSelected: "BTC", secondSelected: "AMD");
        await insertSelectedValue(selectedType);
      } else {
        return false;
      }
    } else {
      upDateDB();
    }
    _selectedType = await getSelectedValueInfo();
    topMoneyType = _selectedType.firstSelected;
    bottomMoneyType = _selectedType.secondSelected;
    BtcCripto topCriptoInfo = await getCriptoInfoViaMoneyType(topMoneyType);
    BtcCripto bottomCriptoInfo =
        await getCriptoInfoViaMoneyType(bottomMoneyType);
    BtcConstants.firstValue = topCriptoInfo.value;
    BtcConstants.secondValue = bottomCriptoInfo.value;
    return true;
  }

  getCurrencyAndCountryName() async {
    String currencyCodeStart = '';
    String currencyCodeEnd = '';
    Map<String, dynamic> currensyAndCountry =
        await _net.makeGetRequestForCurrencyName();
    if (currensyAndCountry.isEmpty) {
      return false;
    }
    for (var currencyCodes in currensyAndCountry.keys) {
      _allCurrencyCodes.add(currencyCodes);
    }
    _allCountryNames = currensyAndCountry;
    int count = _allCurrencyCodes.length;
    currencyCodeStart = await cutListFirst(count, _allCurrencyCodes);
    currencyCodeEnd = await cutListSecond(count, _allCurrencyCodes);
    bool isGetFirstInfo = await getCriptoCurrencyInfo(currencyCodeStart);
    bool isGetSecondInfo = await getCriptoCurrencyInfo(currencyCodeEnd);
    if(!isGetFirstInfo || !isGetSecondInfo){
      return false;
    }
    return true;
  }

  getCriptoCurrencyInfo(String currencyCode) async {
    Map<String, dynamic> criptoCurrencyInfo =
        await _net.makeGetRequestCurrencyInfo(currencyCode);
    if(criptoCurrencyInfo.isEmpty){
      return false;
    }
    await insertDB(criptoCurrencyInfo);
    return true;
  }

  insertDB(Map<String, dynamic> criptoCurrencyInfo) async {
    for (String everyCurrency in criptoCurrencyInfo.keys) {
      BtcCripto criptoCurrency = BtcCripto(
          id: id,
          countryName: _allCountryNames[everyCurrency],
          moneyType: everyCurrency,
          value: criptoCurrencyInfo[everyCurrency],
          flagPath: "assets/$everyCurrency.png");
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
      currencyNames.add(await _db.getCriptoColumnInfo(i, "moneyType"));
    }
    return currencyNames;
  }

  getCriptoCurrencyInfoForUpdate(String currencyCode) async {
    Map<String, dynamic> criptoCurrencyInfo =
        await _net.makeGetRequestCurrencyInfo(currencyCode);
    if(criptoCurrencyInfo.isNotEmpty){
      upDateCripto(criptoCurrencyInfo);
    }
  }

  createMapforUpdate(num value) {
    return {
      "value": value,
    };
  }

  upDateCripto(Map<String, dynamic> criptoCurrencyInfo) async {
    for (String everyCurrency in criptoCurrencyInfo.keys) {
      await _db.updateCripto(
          everyCurrency, createMapforUpdate(criptoCurrencyInfo[everyCurrency]));
    }
  }

  upDateDB() async {
    List currencyNames = [];
    String currencyName = '';
    int rowCount = await _db.getRawCount();
    currencyNames = await getCurrencynamesForURL(rowCount);
    currencyName = cutListFirst(currencyNames.length, currencyNames);
    await getCriptoCurrencyInfoForUpdate(currencyName);
    currencyName = cutListSecond(currencyNames.length, currencyNames);
    await getCriptoCurrencyInfoForUpdate(currencyName);
  }

  getCriptoColumnInfo(int id, String columnName) async {
    return await _db.getCriptoColumnInfo(id, columnName);
  }

  getCriptoInfoViaId(int id) async {
    return await _db.getCriptoInfoViaId(id);
  }

  getCriptoInfoViaMoneyType(String moneyType) async {
    return await _db.getCriptoInfoViaMoneyType(moneyType);
  }

  getAllCriptoInfo() async {
    List<BtcCripto> allInfoCripto = [];
    List allInfo = await _db.getAllCriptoInfo();
    for (int i = 0; i < allInfo.length; ++i) {
      allInfoCripto.add(BtcCripto(
          id: allInfo[i]["id"],
          countryName: allInfo[i]["countryName"],
          moneyType: allInfo[i]["moneyType"],
          value: allInfo[i]["value"],
          flagPath: allInfo[i]["flagPath"]));
    }
    return allInfoCripto;
  }

  getSelectedValueInfo() async {
    return await _db.getSelectedValueInfo();
  }

  getRawCount() async {
    return await _db.getRawCount();
  }

  updateSelectedValue(Map<String, String> selectedValue) async {
    await _db.updateSelectedValue(selectedValue);
  }

  insertSelectedValue(BtcSelectedType selectedType) async {
    await _db.insertSelectedValue(selectedType);
  }
}
