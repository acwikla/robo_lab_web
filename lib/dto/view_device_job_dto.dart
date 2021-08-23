import 'dart:convert';

class ViewDeviceJobDto {
  ViewDeviceJobDto(
      {required this.id,
      required this.deviceId,
      required this.jobId,
      required this.createdDate,
      required this.executionTime,
      required this.body});

  int id;
  int deviceId;
  int jobId;
  String createdDate;
  String executionTime;
  String body;

  String toJson() => json.encode(toMap());

  factory ViewDeviceJobDto.fromMap(Map<String, dynamic> json) =>
      ViewDeviceJobDto(
          id: json["id"],
          deviceId: json["deviceId"],
          jobId: json["job"]["id"],
          createdDate: json["createdDate"],
          executionTime: json["executionTime"],
          body: json["body"]);

  Map<String, dynamic> toMap() =>
      {"executionTime": executionTime, "body": body};

  factory ViewDeviceJobDto.fromJson(Map<String, dynamic> json) {
    return ViewDeviceJobDto(
        id: json["id"],
        deviceId: json["deviceId"],
        jobId: json["job"]["id"],
        createdDate: json["createdDate"],
        executionTime: json["executionTime"],
        body: json["body"]);
  }
}
