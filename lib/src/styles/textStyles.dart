import 'package:bitcoin_converter/src/utils/constants.dart';
import 'package:flutter/material.dart';

///Creates all the text styles which are used in app.
class AppTextStyles {
  AppTextStyles();
  TextStyle primaryTextStyle =
  TextStyle(fontSize: 14, color: BtcConstants.colors.white);
  TextStyle white16 =
  TextStyle(fontSize: 16, color: BtcConstants.colors.white);
  TextStyle black16 =
  TextStyle(fontSize: 16, color: BtcConstants.colors.black);
  TextStyle red14 =
  TextStyle(fontSize: 16, color: BtcConstants.colors.red);
  TextStyle gray14 =
  TextStyle(fontSize: 16, color: BtcConstants.colors.gray);
}