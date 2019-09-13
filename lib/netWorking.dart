import 'dart:convert';
import 'package:http/http.dart';

class NetWorking {
  String _apiKey;
  String _criptoInfoURL;
  String _countryNameURL;

  NetWorking() {
    _apiKey =
        'api_key=775ee409575020e8186ebd2339869437c62b648c06bd63d2baf2e8f794bebe00';
    _countryNameURL = 'https://openexchangerates.org/api/currencies.json';
  }

  makeGetRequestForCurrencyName() async {
    Response response = await get(_countryNameURL);
    if (response.statusCode == 200) {
      Map<String, dynamic> decoded = json.decode(response.body);
      return decoded;
    } else {
      throw Exception(response.statusCode);
    }
  }

  makeGetRequestCurrencyInfo(String currencyCode) async {
    _criptoInfoURL =
        'https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=${currencyCode}&${_apiKey}';
    Response response = await get(_criptoInfoURL);
    if (response.statusCode == 200) {
      Map<String, dynamic> decoded = json.decode(response.body);
      return decoded;
    } else {
      throw Exception(response.statusCode);
    }
  }
}
