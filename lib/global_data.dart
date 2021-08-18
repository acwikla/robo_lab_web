import 'package:robo_lab_web/dto/device_type_dto.dart';
import 'package:robo_lab_web/dto/view_device_dto.dart';
import 'package:robo_lab_web/dto/view_user_dto.dart';

class GlobalData {
  static final DeviceTypeDTO globalDeviceType =
      DeviceTypeDTO(name: 'Dobot Magician V2', id: 3);

  static final ViewUserDTO globalUser = ViewUserDTO(
      id: 3, login: 'RoboLab User', email: 'roboLab.email@gmail.com');

  static final ViewDeviceDto globalDevice = ViewDeviceDto(
      id: 100,
      name: 'Dobot Magician V2 (RoboArm)',
      deviceType: globalDeviceType,
      user: globalUser);
}
