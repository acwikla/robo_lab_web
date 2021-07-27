import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeviceController extends GetxController {
  static DeviceController instance = Get.find();

  Future<ViewDevice> fetchDeviceTemp(int userId) async {
    final response = await http
        .get(Uri.parse('https://localhost:5001/api/users/${userId}/devices/1'));

    if (response.statusCode == 200) {
      return ViewDevice.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch device for user id: ${userId}');
    }
  }
}

class ViewDevice {
  final int id;
  final String name;
  final String deviceTypeName;

  ViewDevice(
      {required this.id, required this.name, required this.deviceTypeName});

  factory ViewDevice.fromJson(Map<String, dynamic> json) {
    return ViewDevice(
        id: json['id'],
        name: json['name'],
        deviceTypeName: json['deviceType']['name']);
  }
}
