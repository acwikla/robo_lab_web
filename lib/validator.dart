class Validator {
  static String? notNullOrEmpty(String? value) {
    if (value == null || value.isEmpty) return 'Please enter some data';
    return null;
  }
}
