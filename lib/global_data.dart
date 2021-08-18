import 'package:robo_lab_web/dto/device_type_dto.dart';
import 'package:robo_lab_web/dto/view_device_dto.dart';
import 'package:robo_lab_web/dto/view_user_dto.dart';

class GlobalData {
  static final DeviceTypeDTO globalDeviceType =
      DeviceTypeDTO(name: 'SmartTerra', id: 1);

  static final ViewUserDTO globalUser =
      ViewUserDTO(id: 1, login: 'ola', email: 'buuu.email@gmail.com');

  static final ViewDeviceDto globalDevice = ViewDeviceDto(
      id: 1,
      name: 'Test device 1 (SmartTerra)',
      deviceType: globalDeviceType,
      user: globalUser);
}
