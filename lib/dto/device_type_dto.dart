import 'dart:convert';

class DeviceTypeDTO {
  DeviceTypeDTO({
    required this.name,
    required this.id,
  });

  String name;
  int id;

  factory DeviceTypeDTO.fromJson(String str) =>
      DeviceTypeDTO.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DeviceTypeDTO.fromMap(Map<String, dynamic> json) => DeviceTypeDTO(
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "id": id,
      };
}
