import 'package:bitcoin_converter/src/bloc/change_currency_bloc.dart';
import 'package:bitcoin_converter/src/database/db_provider.dart';
import 'package:bitcoin_converter/src/models/currency.dart';

class BtcConstants {
  static double screenHeight;
  static double screenWidth;
  static double firstValue;
  static double secondValue;
  static DatabaseHelper db;
  static String apiKey;
  static String countryNameURL;
  static String criptoInfoURL;
  static bool connectionStatus;
  static List<BtcCripto> allCriptoList;
  static BtcChangeCurrencyBloc changeCurrencyBloc;
  BtcConstants() {
    db = DatabaseHelper.internal();
    screenHeight = 0.0;
    screenWidth = 0.0;
    firstValue = 0.0;
    secondValue = 0.0;
    apiKey =
    'api_key=775ee409575020e8186ebd2339869437c62b648c06bd63d2baf2e8f794bebe00';
    countryNameURL = 'https://openexchangerates.org/api/currencies.json';
    criptoInfoURL =
    'https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=';
    connectionStatus = true;
    allCriptoList = [];
    changeCurrencyBloc = BtcChangeCurrencyBloc();
  }
}