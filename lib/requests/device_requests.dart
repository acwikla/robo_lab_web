import 'package:robo_lab_web/dto/view_device_dto.dart';

import '../config.dart';
import 'requests_helper.dart';
import 'package:http/http.dart' as http;

class DeviceRequests {
  static final String baseUrl = Config.ApiAddress + '/devices';

  static Future<List<ViewDeviceDto>> getDevices() async {
    return await RequestsHelper.getReturnList<ViewDeviceDto>(
        baseUrl, (map) => ViewDeviceDto.fromMap(map));
  }

  static Future<ViewDeviceDto> addDevice(
      String? newDeviceName, int? deviceTypeId) async {
    final response = await http.post(
      Uri.parse(Config.ApiAddress +
          '/users/1/device?deviceTypeId=$deviceTypeId&DeviceName=$newDeviceName'),
      headers: <String, String>{
        'accept': 'text/plain',
        //'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
      print(response.statusCode);
      return ViewDeviceDto.fromJson(response.body);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      print(response.body);
      print(response.statusCode);
      throw Exception(response.body);
    }
  }
  //  return await RequestsHelper.post<ViewDeviceDto>(
  //      '/users/1/device?Name=$deviceTypeName&DeviceName=$newDeviceName',
  //      (map) => ViewDeviceDto.fromMap(map));
  //}
}
