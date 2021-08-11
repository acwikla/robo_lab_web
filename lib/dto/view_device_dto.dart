import 'dart:convert';

import 'device_type_dto.dart';
import 'view_user_dto.dart';

class ViewDeviceDto {
  ViewDeviceDto({
    required this.id,
    required this.name,
    required this.deviceType,
    required this.user,
  });

  int id;
  String name;
  DeviceTypeDTO deviceType;
  ViewUserDTO user;

  factory ViewDeviceDto.fromJson(String str) =>
      ViewDeviceDto.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ViewDeviceDto.fromMap(Map<String, dynamic> json) => ViewDeviceDto(
        id: json["id"],
        name: json["name"],
        deviceType: DeviceTypeDTO.fromMap(json["deviceType"]),
        user: ViewUserDTO.fromMap(json["user"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "deviceType": deviceType.toMap(),
        "user": user.toMap(),
      };
}
