class JobBody {
  JobBody({
    this.name,
    this.value,
  });

  String? name;
  String? value;

  static String changeListToString(List<JobBody> jobBody) {
    String stringJobsProperties = '';
    for (int i = 0; i < jobBody.length; i++) {
      stringJobsProperties += jobBody[i].name! + ':' + jobBody[i].value! + ';';
    }
    return stringJobsProperties;
  }
}
