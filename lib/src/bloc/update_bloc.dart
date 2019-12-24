import 'dart:async';
import 'package:bitcoin_converter/src/bloc/base_bloc.dart';
import 'package:rxdart/rxdart.dart';

class BtcAllListBloc extends BtcBaseBloc {
  BtcAllListBloc() {
    _allListController.stream.listen(exchangeValue);

  }

  StreamController _allListController = StreamController();



  Stream get list => _allListStream.stream;
  Sink get addValue => _allListStream.sink;

  final _allListStream = BehaviorSubject();

  StreamSink get sink => _allListController.sink;

  void exchangeValue(data) async {

    addValue.add(await getAllCriptoInfo());
  }

  getRequest() async {}

  getAllCriptoInfo() async {
    return await repository.getAllCriptoInfo();
  }

  updateSelectedValue(Map<String, String> selectedValue) async {
    await repository.updateSelectedValue(selectedValue);
  }

  @override
  dispose() {
    _allListController.close();
    _allListStream.close();
  }
}