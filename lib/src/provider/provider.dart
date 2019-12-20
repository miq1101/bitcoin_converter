import 'dart:convert';
import 'package:bitcoin_converter/src/utils/constants.dart';
import 'package:http/http.dart';

class BtcProvider {
  String _apiKey;
  String _criptoInfoURL;

  BtcProvider() {
    _apiKey = BtcConstants.apiKey;
  }

  makeGetRequestForCurrencyName() async {
    Response response = await get(BtcConstants.countryNameURL);
    if (response.statusCode == 200) {
      Map<String, dynamic> decoded = json.decode(response.body);
      return decoded;
    } else {
      throw Exception(response.statusCode);
    }
  }

  makeGetRequestCurrencyInfo(String currencyCode) async {
    _criptoInfoURL = BtcConstants.criptoInfoURL + '${currencyCode}&${_apiKey}';
    Response response = await get(_criptoInfoURL);
    if (response.statusCode == 200) {
      Map<String, dynamic> decoded = json.decode(response.body);
      return decoded;
    } else {
      throw Exception(response.statusCode);
    }
  }
}