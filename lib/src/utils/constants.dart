import 'package:bitcoin_converter/src/bloc/change_currency_bloc.dart';
import 'package:bitcoin_converter/src/database/db_provider.dart';
import 'package:bitcoin_converter/src/models/currency.dart';
import 'package:bitcoin_converter/src/styles/colors.dart';
import 'package:bitcoin_converter/src/styles/strings.dart';
import 'package:bitcoin_converter/src/styles/textStyles.dart';

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
  static AppColors colors;
  static AppTextStyles textStyles;
  static AppStrings strings;
  BtcConstants() {
    db = DatabaseHelper.internal();
    colors = AppColors();
    textStyles = AppTextStyles();
    strings = AppStrings();
    screenHeight = 0.0;
    screenWidth = 0.0;
    firstValue = 0.0;
    secondValue = 0.0;
    apiKey = strings.apiKey;
    countryNameURL = strings.countryNameURL;
    criptoInfoURL = strings.criptoInfoURL;
    connectionStatus = true;
    allCriptoList = [];
    changeCurrencyBloc = BtcChangeCurrencyBloc();
  }
}
