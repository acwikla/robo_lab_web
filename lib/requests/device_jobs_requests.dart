import 'package:robo_lab_web/dto/device_job_dto.dart';
import '../config.dart';
import 'requests_helper.dart';

class DeviceJobsRequests {
  static final String baseUrl = Config.ApiAddress + '/device-jobs​';

  /*static Future<List<DeviceJobDto>> getJobsForDevType(int deviceId, int jobId, DeviceJobDto devJob) async {
    return await RequestsHelper.get<DeviceJobDto>(
        baseUrl + '/​device​/$deviceId​/job​/$jobId', 
        (devJob) => DeviceJobDto.toMap(devJob));
  }*/
}
