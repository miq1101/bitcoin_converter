class BtcCripto {
  int id;
  String countryName;
  String moneyType;
  num value;
  String flagPath;

  BtcCripto(
      {this.id, this.countryName, this.moneyType, this.value, this.flagPath});

  factory BtcCripto.fromJson(Map<String, dynamic> json) => BtcCripto(
    id: json["id"] as int,
    countryName: json["countryName"] as String,
    moneyType: json["moneyType"] as String,
    value: json["value"] as num,
    flagPath: json["flagPath"] as String,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "moneyType": moneyType,
    "value": value,
    "countryName": countryName,
    "flagPath": flagPath,
  };
}