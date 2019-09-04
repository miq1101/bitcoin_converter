import 'dart:convert';

String criptoToJson(Cripto data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Cripto {
  int id;
  String moneyType;
  num value;
  String flagPath;

  Cripto({this.id, this.moneyType, this.value, this.flagPath});

  factory Cripto.fromJson(Map<String, dynamic> json) => Cripto(
      id: json["id"],
      moneyType: json["moneyType"],
      value: json["value"],
      flagPath: json["flagPath"]);

  Map<String, dynamic> toJson() =>
      {"id": id, "moneyType": moneyType, "value": value, "flagPath": flagPath};
}
