import 'package:robo_lab_web/dto/job_dto.dart';
import '../config.dart';
import 'requests_helper.dart';

class JobRequests {
  static final String baseUrl = Config.ApiAddress + '/jobs';

  static Future<List<JobDto>> getJobsForDevType(String devTypeName) async {
    return await RequestsHelper.getReturnList<JobDto>(
        baseUrl + '?devtype=$devTypeName', (map) => JobDto.fromMap(map));
  }
}
