import 'dart:core';

import 'currensy.dart';
import 'dbFunctions.dart';
import 'mainScreen.dart';
import 'package:flutter/material.dart';


void main() async{


  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Currency(currencyName: "USD"),
  ));
}