import 'dart:async';

import 'package:bitcoin_converter/src/bloc/base_bloc.dart';
import 'package:bitcoin_converter/src/models/currency.dart';
import 'package:bitcoin_converter/src/models/selected_type.dart';
import 'package:bitcoin_converter/src/utils/constants.dart';
import 'package:rxdart/rxdart.dart';

class BtcChangeCurrencyBloc extends BtcBaseBloc {
  BtcChangeCurrencyBloc() {
    _exchangeFirstController.stream.listen(changeFirstSelected);
    _exchangeSecondController.stream.listen(changeSecondSelected);
    _exchangeController.stream.listen(exchangeValue);
    _allListController.stream.listen(updateValue);
    _listForSelectController.stream.listen(selectValue);
    value = "0.0";
    searchText = "";
  }

  StreamController _exchangeFirstController = StreamController();
  StreamController _exchangeSecondController = StreamController();
  StreamController _exchangeController = StreamController();
  StreamController _allListController = StreamController();
  StreamController _listForSelectController = StreamController();

  int _rowCount;
  String value;
  String searchText;
  set setValue(String topValue) => value = topValue;
  set setSearchText(String searchInput) => searchText = searchInput;

  Stream get change => _exchangeStream.stream;
  Stream get changeFirst => _firstStream.stream;
  Stream get changeSecond => _secondStream.stream;
  Stream get list => _allListStream.stream;
  Stream get listSelect => _listForSelectStream.stream;

  final _firstStream = BehaviorSubject();
  final _secondStream = BehaviorSubject();
  final _exchangeStream = BehaviorSubject<String>.seeded("0.0");
  final _allListStream = BehaviorSubject();
  final _listForSelectStream = BehaviorSubject();

  Sink get addFirstValue => _firstStream.sink;
  Sink get addSecondValue => _secondStream.sink;
  Sink get addExchangeValue => _exchangeStream.sink;
  Sink get addUpdateValue => _allListStream.sink;
  Sink get addSelectValue => _listForSelectStream.sink;

  StreamSink get firstSink => _exchangeFirstController.sink;
  StreamSink get secondSink => _exchangeSecondController.sink;
  StreamSink get exchangeSink => _exchangeController.sink;
  StreamSink get allListSink => _allListController.sink;
  StreamSink get allListForSelectSink => _listForSelectController.sink;

  void changeFirstSelected(data) async {
    String firstSelected;
    BtcCripto cripto;
    if (_rowCount == 0) {
      addFirstValue.add(null);
    } else {
      firstSelected = (await repository.getSelectedValueInfo()).firstSelected;
      cripto = await repository.getCriptoInfoViaMoneyType(firstSelected);
      BtcConstants.firstValue = cripto.value;
    }
    addFirstValue.add(cripto);
  }

  void changeSecondSelected(data) async {
    String secondSelected;
    BtcCripto cripto;
    if (_rowCount == 0) {
      addFirstValue.add(null);
    } else {
      secondSelected = (await repository.getSelectedValueInfo()).secondSelected;
      cripto = await repository.getCriptoInfoViaMoneyType(secondSelected);
      BtcConstants.secondValue = cripto.value;
    }
    addSecondValue.add(cripto);
  }

  void exchangeValue(data) async {
    double topValue = BtcConstants.firstValue;
    double bottomValue = BtcConstants.secondValue;
    double parseValue = double.tryParse(value) ?? -1;
    if (parseValue == -1) {
      addExchangeValue.add(parseValue.toString());
    } else {
      double finalValue = parseValue * bottomValue / topValue;
      addExchangeValue.add(finalValue.toString());
    }
  }

  replaceCurrency() async {
    BtcSelectedType selectedForReplace = await getSelectedValue();
    updateSelectedValue({"firstSelected": selectedForReplace.secondSelected});
    BtcConstants.firstValue =
       await getValueViaMoneyType(selectedForReplace.secondSelected);

    updateSelectedValue({"secondSelected": selectedForReplace.firstSelected});
    BtcConstants.secondValue =
       await getValueViaMoneyType(selectedForReplace.firstSelected);

    firstSink.add(null);
    secondSink.add(null);
    exchangeSink.add(null);
    updateSelectedValue({
      "firstSelected": selectedForReplace.secondSelected,
      "secondSelected": selectedForReplace.firstSelected
    });
  }

  void updateValue(data) async {
    addUpdateValue.add(await getAllCriptoInfo());
  }

  void selectValue(data) async {
    if (searchText == "") {
      addSelectValue.add(BtcConstants.allCriptoList);
    } else {
      searchText[0].toLowerCase();
      List<BtcCripto> searchList = [];
      for (var criptoElement in BtcConstants.allCriptoList) {
        if (criptoElement.countryName[0] == searchText[0] &&
            criptoElement.countryName.contains(searchText)) {
          searchList.add(criptoElement);
        }
      }
      addSelectValue.add(searchList);
    }
  }

  void getRequests() async {
    _rowCount = await repository.getRawCount();
    firstSink.add(null);
    secondSink.add(null);
    allListSink.add(null);
  }

  void updateDb() async {
    repository.getDB();

    exchangeSink.add(null);
    allListSink.add(null);
  }

  getAllCriptoInfo() async {
    BtcConstants.allCriptoList = await repository.getAllCriptoInfo();
    return BtcConstants.allCriptoList;
  }

  updateSelectedValue(Map<String, String> selectedValue) async {
    await repository.updateSelectedValue(selectedValue);
  }

  getSelectedValue() async {
    return await repository.getSelectedValueInfo();
  }

  getValueViaMoneyType(String moneyType) async {
    return (await repository.getCriptoInfoViaMoneyType(moneyType)).value;
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
    _exchangeController.close();
    _exchangeStream.close();
    _allListController.close();
    _allListStream.close();
    _listForSelectController.close();
    _listForSelectStream.close();
  }
}
