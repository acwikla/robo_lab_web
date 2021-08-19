import 'dart:convert';

class DeviceJobDto {
  DeviceJobDto({
    this.executionTime,
    this.body,
  });

  String? executionTime;
  String? body;

  factory DeviceJobDto.fromJson(String str) =>
      DeviceJobDto.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DeviceJobDto.fromMap(Map<String, dynamic> json) =>
      DeviceJobDto(executionTime: json["executionTime"], body: json["body"]);

  Map<String, dynamic> toMap() =>
      {"executionTime": executionTime, "body": body};
}
