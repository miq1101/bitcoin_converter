class BtcCripto {
  int id;
  String countryName;
  String moneyType;
  num value;
  String flagPath;

  BtcCripto(
      {this.id, this.countryName, this.moneyType, this.value, this.flagPath});

  factory BtcCripto.fromJson(Map<String, dynamic> json) => BtcCripto(
    id: json["id"],
    countryName: json["countryName"],
    moneyType: json["moneyType"],
    value: json["value"],
    flagPath: json["flagPath"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "moneyType": moneyType,
    "value": value,
    "countryName": countryName,
    "flagPath": flagPath,
  };
}