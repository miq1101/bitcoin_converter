import 'dart:core';

import 'currensy.dart';
import 'dbFunctions.dart';
import 'mainScreen.dart';
import 'package:flutter/material.dart';


void main() async{


  DatabaseHelper db = DatabaseHelper.internal();
  db.makeGetRequestForCurrencyName();
//  Cripto dollar = Cripto(moneyType: 'USD',value: 475.0);
//  Cripto euro = Cripto(moneyType: 'EUR',value: 580.0);

// await db.database;
//  await db.makeGetRequest();
//
//  await db.updateAllCriptoInfo();
  //db.deleteCripto(0.0);
//  await db.newCripto(dollar);
//  await db.newCripto(euro);
  // print(((await db.getCripto("AMD"))));
//  MoneyType allValues = await db.makeGetRequest();
//  int dollartId = await db.getCriptoId('USD');
//  int euroId = await db.getCriptoId('EUR');
//  dollar = Cripto(id:dollartId,moneyType:"USD",value: allValues.amd);
//  euro = Cripto(id:euroId,moneyType:"EUR",value: allValues.jpy);

  //print((await db.getAllCripto()));

//  await db.updateCripto(euro);
//   db.deleteCripto(1);
//   db.deleteCripto(2);
//   db.deleteCripto(3);
//   db.deleteCripto(4);
//   db.deleteCripto(5);
//   db.deleteCripto(6);
//   db.deleteCripto(7);
//   db.deleteCripto(8);
//  print(await db.getAllCripto());
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Currency(currencyName: "USD"),
  ));
}