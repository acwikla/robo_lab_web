import 'dart:convert';

import 'job_dto.dart';

class ViewDeviceJobDto {
  ViewDeviceJobDto(
      {required this.id,
      required this.deviceId,
      required this.done,
      required this.title,
      //required this.jobId,
      //required this.createdDate,
      //required this.executionTime,
      required this.body,
      required this.job});

  int id;
  int deviceId;
  bool done;
  //String createdDate;
  //String executionTime;
  String body;
  JobDto job;
  String title;

  factory ViewDeviceJobDto.fromJson(String str) =>
      ViewDeviceJobDto.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ViewDeviceJobDto.fromMap(Map<String, dynamic> json) =>
      ViewDeviceJobDto(
          id: json["id"],
          deviceId: json["deviceId"],
          done: json["done"],
          title: json["title"],
          // createdDate: json["createdDate"],
          // executionTime: json["executionTime"],
          body: json["body"],
          job: JobDto.fromMap(json["job"]));

  Map<String, dynamic> toMap() => {
        "id": id,
        "deviceId": deviceId,
        "done": done,
        "title": title,
        //"createdDate": createdDate,
        //"executionTime": executionTime,
        "body": body,
        "job": job.toMap()
      };
}
