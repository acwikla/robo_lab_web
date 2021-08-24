import 'dart:convert';

class ViewDeviceValueDto {
  ViewDeviceValueDto({
    required this.id,
    required this.value,
    required this.dateTime,
    required this.propertyId,
    //required this.deviceId,
    required this.deviceJobId,
    required this.propertyName,
  });

  int id;
  String value;
  DateTime dateTime;
  int propertyId;
  String propertyName;
  //int deviceId;
  int deviceJobId;

  factory ViewDeviceValueDto.fromJson(String str) =>
      ViewDeviceValueDto.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ViewDeviceValueDto.fromMap(Map<String, dynamic> json) =>
      ViewDeviceValueDto(
        id: json["id"],
        value: json["val"],
        dateTime: DateTime.parse(json["dateTime"]),
        propertyId: json["propertyId"],
        //do zmiany jak zmienie klase: ViewDeviceValueDTO(Api)
        propertyName: json["property"]["name"],
        //deviceId: json["deviceId"],
        deviceJobId: json["deviceJobId"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "value": value,
        "dateTime": dateTime,
        "propertyId": propertyId,
        "propertyName": propertyName,
        //"deviceId": deviceId,
        "deviceJobId": deviceJobId,
      };
}
