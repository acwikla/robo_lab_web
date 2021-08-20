import 'dart:convert';

import 'package:robo_lab_web/dto/device_job_dto.dart';
import '../config.dart';
import 'requests_helper.dart';
import 'package:http/http.dart' as http;

class DeviceJobsRequests {
  static final String baseUrl = Config.ApiAddress + '/device-jobs​';

  static Future<DeviceJobDto> postDeviceJob(
      int deviceId, int jobId, DeviceJobDto devJob) async {
    final response = await http.post(
      Uri.parse(
          'http://51.158.163.165/api/device-jobs/device/$deviceId/job/$jobId'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "executionTime": devJob.executionTime.toString(),
        "body": devJob.body.toString(),
      }),
    );

    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return DeviceJobDto.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to submit job.');
    }
  }
}
