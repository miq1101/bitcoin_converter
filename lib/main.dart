import 'dart:core';

import 'controller.dart';

import 'mainScreen.dart';
import 'package:flutter/material.dart';

import 'noConnection.dart';

void main() async {
  Controller cntler = Controller();
  bool dbIsEmpty = await cntler.getDB();
  if(dbIsEmpty) {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ConvertScreen(),
    ));
  }
  else{
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NoConnection(),
    ));
  }
}
