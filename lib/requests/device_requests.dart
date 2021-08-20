import 'package:robo_lab_web/dto/view_device_dto.dart';

import '../config.dart';
import 'requests_helper.dart';

class DeviceRequests {
  static final String baseUrl = Config.ApiAddress + '/devices';

  static Future<List<ViewDeviceDto>> getDevices() async {
    return await RequestsHelper.getReturnList<ViewDeviceDto>(
        baseUrl, (map) => ViewDeviceDto.fromMap(map));
  }
}
