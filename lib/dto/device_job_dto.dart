import 'dart:convert';

class DeviceJobDto {
  DeviceJobDto({this.executionTime, this.body, required this.title});

  String? executionTime;
  String? body;
  String title;

  //factory DeviceJobDto.fromJson(String str) =>
  //DeviceJobDto.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DeviceJobDto.fromMap(Map<String, dynamic> json) => DeviceJobDto(
      title: json["title"],
      executionTime: json["executionTime"],
      body: json["body"]);

  Map<String, dynamic> toMap() =>
      {"executionTime": executionTime, "body": body};

  factory DeviceJobDto.fromJson(Map<String, dynamic> json) {
    return DeviceJobDto(
        title: json["title"],
        executionTime: json["executionTime"],
        body: json["body"]);
  }
}
