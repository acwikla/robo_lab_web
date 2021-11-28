import 'dart:convert';

class AddPropertyDto {
  AddPropertyDto({this.name, required this.body, this.isMode});

  late String? name;
  late Map<String, String?> body;
  late bool? isMode;

  //_map = {};

  void set(String name, String? value) {
    body[name] = value;
  }

  String toJson() => json.encode(toMap());

  factory AddPropertyDto.fromMap(Map<String, dynamic> json) => AddPropertyDto(
      name: json["name"], body: json["body"], isMode: json["isMode"]);

  Map<String, dynamic> toMap() =>
      {"name": name, "body": body, "isMode": isMode};

  factory AddPropertyDto.fromJson(Map<String, dynamic> json) {
    return AddPropertyDto(
        name: json["name"], body: json["body"], isMode: json["isMode"]);
  }
}
