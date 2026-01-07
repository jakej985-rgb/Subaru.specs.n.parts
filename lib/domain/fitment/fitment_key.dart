class FitmentKey {
  static String norm(String s) =>
      s.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  static String ymmKey(int year, String make, String model) =>
      '$year|${norm(make)}|${norm(model)}';

  static String ymmtKey(int year, String make, String model, String? trim) =>
      '${ymmKey(year, make, model)}|${trim == null ? '' : norm(trim)}';
}
