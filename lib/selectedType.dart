import 'dart:convert';

String SelectedTypeToJson(SelectedType data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class SelectedType {
  String firstSelected;
  String secondSelected;

  SelectedType({this.firstSelected, this.secondSelected});

  factory SelectedType.fromJson(Map<String, dynamic> json) => SelectedType(
        firstSelected: json["firstSelected"],
        secondSelected: json["secondSelected"],
      );

  Map<String, dynamic> toJson() => {
        "firstSelected": firstSelected,
        "secondSelected": secondSelected,
      };
}
