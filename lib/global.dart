import 'package:robo_lab_web/dto/device_type_dto.dart';
import 'package:robo_lab_web/dto/job_dto.dart';
import 'package:robo_lab_web/dto/view_device_dto.dart';
import 'package:robo_lab_web/dto/view_device_job_dto.dart';
import 'package:robo_lab_web/dto/view_user_dto.dart';

class Global {
  static final ViewUserDTO user = ViewUserDTO(
      id: 3, login: 'RoboLab User', email: 'roboLab.email@gmail.com');

  static DeviceTypeDTO deviceType =
      DeviceTypeDTO(name: 'Dobot Magician V2', id: 3);

  static ViewDeviceDto device = ViewDeviceDto(
      id: 100,
      name: 'Dobot Magician V2 (RoboArm)',
      deviceType: deviceType,
      user: user);

  static ViewDeviceJobDto deviceJob = ViewDeviceJobDto(
      id: 599,
      deviceId: 120,
      done: true,
      job: JobDto(
          description: "",
          deviceTypeName: "",
          id: 120,
          name: "",
          properties: ""),
      // createdDate: "0001-01-01T00:00:00",
      // executionTime: "2021-08-24T04:23:47.331Z",
      body: "example body");
}
