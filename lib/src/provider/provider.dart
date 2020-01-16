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
    Map<String, dynamic> decoded = json.decode(response.body);
    if (decoded.containsKey("Response")) {
      Map<String, dynamic> errorResponse = {};
      return errorResponse;
    }
    return decoded;
  }

  makeGetRequestCurrencyInfo(String currencyCode) async {
    _criptoInfoURL = BtcConstants.criptoInfoURL + '${currencyCode}${_apiKey}';
    Response response = await get(_criptoInfoURL);
    Map<String, dynamic> decoded = json.decode(response.body);
    print(decoded);
    if (decoded.containsKey("Response")) {
      Map<String, dynamic> errorResponse = {};
      return errorResponse;
    }
    return decoded;
  }
}
