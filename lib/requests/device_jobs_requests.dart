import 'dart:convert';

import 'package:robo_lab_web/dto/device_job_dto.dart';
import 'package:robo_lab_web/dto/view_device_job_dto.dart';
import 'package:robo_lab_web/dto/view_device_value_dto.dart';
import '../config.dart';
import 'requests_helper.dart';
import 'package:http/http.dart' as http;

class DeviceJobsRequests {
  static final String baseUrl = Config.ApiAddress + '/device-jobs';

  static Future<List<ViewDeviceValueDto>> getDeviceJobValues(int id) async {
    return await RequestsHelper.getReturnList<ViewDeviceValueDto>(
        baseUrl + '/$id/get-all-job-values',
        (map) => ViewDeviceValueDto.fromMap(map));
  }

  // create new device job for device
  static Future<DeviceJobDto> postDeviceJob(
      int deviceId, int jobId, DeviceJobDto devJob) async {
    final response = await http.post(
      Uri.parse(baseUrl + '/device/$deviceId/job/$jobId'),
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
      throw Exception('Failed to sumbit job.');
    }
  }

  // get all device jobs for specific device
  static Future<List<ViewDeviceJobDto>> getDeviceJobsForDevice(
      int deviceId) async {
    return await RequestsHelper.getReturnList<ViewDeviceJobDto>(
        baseUrl + '/device/$deviceId', (map) => ViewDeviceJobDto.fromMap(map));
  }
}
