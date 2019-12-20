import 'dart:async';

import 'package:bitcoin_converter/src/bloc/base_bloc.dart';
import 'package:bitcoin_converter/src/models/currency.dart';
import 'package:rxdart/rxdart.dart';

class BtcChangeCurrencyBloc extends BtcBaseBloc {
  BtcChangeCurrencyBloc() {
    _exchangeFirstController.stream.listen(changeFirstSelected);
    _exchangeSecondController.stream.listen(changeSecondSelected);
  }

  StreamController _exchangeFirstController = StreamController();
  StreamController _exchangeSecondController = StreamController();

  final _firstStream = BehaviorSubject();
  final _secondStream = BehaviorSubject();

  Stream get changeFirst => _firstStream.stream;
  Sink get addFirstValue => _firstStream.sink;

  Stream get changeSecond => _secondStream.stream;
  Sink get addSecondValue => _secondStream.sink;

  StreamSink get firstSink => _exchangeFirstController.sink;
  StreamSink get secondSink => _exchangeSecondController.sink;

  void changeFirstSelected(data) async {
    String firstSelected =
        (await repository.getSelectedValueInfo()).firstSelected;
    BtcCripto cripto =
    await repository.getCriptoInfoViaMoneyType(firstSelected);
    addFirstValue.add(cripto);
  }

  void changeSecondSelected(data) async {
    String secondSelected =
        (await repository.getSelectedValueInfo()).secondSelected;
    BtcCripto cripto =
    await repository.getCriptoInfoViaMoneyType(secondSelected);
    addSecondValue.add(cripto);
  }

  void getRequests() async {
    await repository.getDB();
    firstSink.add(null);
    secondSink.add(null);
  }

  getAllCriptoInfo() async {
    return await repository.getAllCriptoInfo();
  }

  updateSelectedValue(Map<String, String> selectedValue) async {
    await repository.updateSelectedValue(selectedValue);
  }

  getSelectedValue() async {
    return await repository.getSelectedValueInfo();
  }

  addSink(String position) {
    if (position == "top") {
      firstSink.add(null);
    } else {
      secondSink.add(null);
    }
  }

  @override
  dispose() {
    _exchangeFirstController.close();
    _exchangeSecondController.close();
    _firstStream.close();
    _secondStream.close();
  }
}