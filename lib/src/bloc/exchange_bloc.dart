import 'dart:async';
import 'package:bitcoin_converter/src/bloc/base_bloc.dart';
import 'package:bitcoin_converter/src/utils/constants.dart';
import 'package:rxdart/rxdart.dart';

class BtcExchangeBloc extends BtcBaseBloc {
  BtcExchangeBloc() {
    _exchangeController.stream.listen(exchangeValue);
    value = "0.0";
  }

  StreamController _exchangeController = StreamController();

  String value;
  set setValue(String topValue) => value = topValue;

  Stream get change => _exchangeStream.stream;
  Sink get addValue => _exchangeStream.sink;

  final _exchangeStream = BehaviorSubject<String>.seeded("0.0");

  StreamSink get sink => _exchangeController.sink;

  void exchangeValue(data) async {
    double topValue = BtcConstants.firstValue;
    double bottomValue = BtcConstants.secondValue;
    double finalValue = double.parse(value) * bottomValue / topValue;
    addValue.add(finalValue.toString());
  }

  @override
  dispose() {
    _exchangeController.close();

    _exchangeStream.close();
  }
}