import 'dart:core';
import 'package:bitcoin_converter/src/pages/home_page.dart';
import 'package:bitcoin_converter/src/utils/constants.dart';
import 'package:flutter/material.dart';


void main() async {
  BtcConstants();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BtcHomePage(),
    theme: ThemeData(primaryColor: Color(0xFFed6f0e)),
  ));
}
