import 'model.dart';
import 'selectedType.dart';

class Controller {
  Model _model;

  Controller() {
    _model = Model();
  }
  getDB() async {
    return await _model.getDB();
  }

  upDateDB() async {
    return await _model.upDateDB();
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

  getSelectedValueInfo() async {
    return await _model.getSelectedValueInfo();
  }

  updateSelectedValue(SelectedType selectedType) async {
    await _model.updateSelectedValue(selectedType);
  }
}
