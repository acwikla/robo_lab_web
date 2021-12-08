import 'dart:convert';

import 'package:robo_lab_web/dto/job_dto.dart';
import '../config.dart';
import 'requests_helper.dart';
import 'package:http/http.dart' as http;

class JobRequests {
  static final String baseUrl = Config.ApiAddress + '/jobs';

  static Future<List<JobDto>> getJobsForDevType(String devTypeName) async {
    return await RequestsHelper.getReturnList<JobDto>(
        baseUrl + '?devtype=$devTypeName', (map) => JobDto.fromMap(map));
  }

  static Future<JobDto> createJobForDeviceType(JobDto newJob) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json',
      },
      body: //newJob.toMap(),
          jsonEncode(<String, String>{
        "name": newJob.name,
        "description": newJob.description,
        "properties": newJob.properties,
        "deviceTypeName": newJob.deviceTypeName,
      }),
    );

    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
      print(response.statusCode);
      return JobDto.fromJson(response.body);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      print(response.body);
      print(response.statusCode);
      throw Exception(response.body);
    }
  }
}
