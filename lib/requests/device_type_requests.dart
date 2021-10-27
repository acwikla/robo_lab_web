import 'dart:convert';

import 'package:robo_lab_web/dto/device_type_dto.dart';
import 'package:robo_lab_web/requests/requests_helper.dart';
import '../config.dart';
import 'package:http/http.dart' as http;

class DeviceTypeRequests {
  static final String baseUrl = Config.ApiAddress + '/device-types';

  static Future<List<DeviceTypeDTO>> getDeviceTypes() async {
    return await RequestsHelper.getReturnList<DeviceTypeDTO>(
        baseUrl, (map) => DeviceTypeDTO.fromMap(map));
  }

  static Future<DeviceTypeDTO> createDeviceType(String name) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "name": name.toString(),
      }),
    );

    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
      print(response.statusCode);
      return DeviceTypeDTO.fromJson(response.body);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      print(response.body);
      print(response.statusCode);
      throw Exception(response.body);
    }
  }
}
