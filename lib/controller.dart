import 'model.dart';

class Controller {
  Model _model;

  Controller() {
    _model = Model();
  }
  getDB() async {
    return await _model.getDB();
  }

  upDateDB(Map<String, dynamic> criptoCurrencyInfo) async {
    return _model.upDateDB();
  }

  getCriptoColumnInfo(int id, String columnName) async {
    return _model.getCriptoColumnInfo(id, columnName);
  }

  getCriptoInfoViaId(int id) async {
    return await _model.getCriptoInfoViaId(id);
  }

  getCriptoInfoViaMoneyType(String moneyType) async {
    return _model.getCriptoInfoViaMoneyType(moneyType);
  }

  getAllCriptoInfo() async {
    return _model.getAllCriptoInfo();
  }

  getRawCount() async {
    return _model.getRawCount();
  }
}
