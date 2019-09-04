import 'package:flutter/material.dart';

class Currency extends StatelessWidget {
  // init Currency
  final String currencyName;

  Currency({Key key, @required this.currencyName}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      home: new Scaffold(
        backgroundColor: Colors.blue,

      ),
    );}
}