class JobProperty {
  JobProperty({
    this.name,
    this.type,
    this.value,
    this.min,
    this.max,
  });

  String? name;
  String? value;
  String? type;
  int? min;
  int? max;
  static List<JobProperty>? jobsProperties = [];

  static List<JobProperty> splitString(String properties) {
    List<JobProperty> jobProperties = [];
    if (properties != '') {
      JobProperty jobProperty;
      for (int i = 0; i < properties.length; i++) {
        if (i + 4 < properties.length) {
          String searchString = properties.substring(i, i + 4);
          if (searchString.contains('name')) {
            i += 4;
            for (int j = i; j < properties.length; j++) {
              if (properties[j] == ',') {
                jobProperty =
                    new JobProperty(name: properties.substring(i + 1, j));
                jobProperties.add(jobProperty);
                break;
              }
            }
          }
        }
      }
    }
    return jobProperties;
  }
}
