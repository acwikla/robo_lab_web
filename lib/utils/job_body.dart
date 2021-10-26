class JobBody {
  Map<String, String?> _map = {};

  void set(String name, String? value) {
    _map[name] = value;
  }

  void clear() {
    _map.clear();
  }

  @override
  String toString() {
    String result = '';
    _map.forEach((key, value) {
      result += key + ':' + (value ?? 'null') + ';';
    });
    return result;
  }
}
