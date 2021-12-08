import 'dart:convert';

class JobDto {
  JobDto({
    this.id,
    required this.name,
    required this.description,
    required this.properties,
    required this.deviceTypeName,
  });

  int? id;
  String name;
  String description;
  String properties;
  String deviceTypeName;

  factory JobDto.fromJson(String str) => JobDto.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JobDto.fromMap(Map<String, dynamic> json) => JobDto(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        properties: json["properties"],
        deviceTypeName: json["deviceTypeName"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "properties": properties,
        "deviceTypeName": deviceTypeName,
      };
}
