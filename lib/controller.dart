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
    final db = await _model.upDateDB();
    if (db == null){
      return null;
    }
    return db;
  }

  getCriptoColumnInfo(int id, String columnName) async {
    return await _model.getCriptoColumnInfo(id, columnName);
  }

  getCriptoInfoViaId(int id) async {
    return await _model.getCriptoInfoViaId(id);
  }

  getCriptoInfoViaMoneyType(String moneyType) async {
    return await _model.getCriptoInfoViaMoneyType(moneyType);
  }

  getAllCriptoInfo() async {
    return await _model.getAllCriptoInfo();
  }

  getRawCount() async {
    return await _model.getRawCount();
  }
}
