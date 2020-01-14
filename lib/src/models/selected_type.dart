class BtcSelectedType {
  String firstSelected;
  String secondSelected;

  BtcSelectedType({this.firstSelected, this.secondSelected});

  factory BtcSelectedType.fromJson(Map<String, dynamic> json) =>
      BtcSelectedType(
        firstSelected: json["firstSelected"] as String,
        secondSelected: json["secondSelected"] as String,
      );

  Map<String, dynamic> toJson() => {
    "firstSelected": firstSelected,
    "secondSelected": secondSelected,
  };
}