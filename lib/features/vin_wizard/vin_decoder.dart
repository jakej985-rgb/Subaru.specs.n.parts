class VinResult {
  final int? year;
  final String? model;
  final String? body;
  final String? engine;
  final bool isValid;

  VinResult({
    this.year,
    this.model,
    this.body,
    this.engine,
    this.isValid = false,
  });

  @override
  String toString() => 'VinResult(year: $year, model: $model)';
}

class VinDecoder {
  static VinResult decode(String vin) {
    if (vin.length != 17) return VinResult();
    final cleanVin = vin.toUpperCase();

    // 10th digit = Year
    final yearChar = cleanVin[9];
    int? year = _decodeYear(yearChar);

    // 4th & 5th digits = Model/Body
    final modelCode = cleanVin.substring(3, 5);
    final modelInfo = _decodeModel(modelCode);

    return VinResult(
      year: year,
      model: modelInfo.$1,
      body: modelInfo.$2,
      isValid: year != null && modelInfo.$1 != null,
    );
  }

  static int? _decodeYear(String char) {
    const yearMap = {
      'X': 1999,
      'Y': 2000,
      '1': 2001,
      '2': 2002,
      '3': 2003,
      '4': 2004,
      '5': 2005,
      '6': 2006,
      '7': 2007,
      '8': 2008,
      '9': 2009,
      'A': 2010,
      'B': 2011,
      'C': 2012,
      'D': 2013,
      'E': 2014,
      'F': 2015,
      'G': 2016,
      'H': 2017,
      'J': 2018,
      'K': 2019,
      'L': 2020,
      'M': 2021,
      'N': 2022,
      'P': 2023,
      'R': 2024,
      'S': 2025,
    };
    return yearMap[char];
  }

  static (String?, String?) _decodeModel(String code) {
    const modelMap = {
      'GD': ('Impreza', 'Sedan'),
      'GG': ('Impreza', 'Wagon'),
      'GC': ('Impreza', 'Sedan'),
      'GF': ('Impreza', 'Wagon'),
      'BE': ('Legacy', 'Sedan'),
      'BH': ('Legacy', 'Wagon'),
      'SF': ('Forester', 'SUV'),
      'SG': ('Forester', 'SUV'),
      'SH': ('Forester', 'SUV'),
      'SJ': ('Forester', 'SUV'),
      'SK': ('Forester', 'SUV'),
      'BP': ('Outback', 'Wagon'),
      'BL': ('Legacy', 'Sedan'),
      'GR': ('Impreza', 'Hatch'),
      'GV': ('Impreza', 'Sedan'),
      'VA': ('WRX', 'Sedan'),
      'BR': ('Legacy', 'Wagon'), // or Outback
      'BM': ('Legacy', 'Sedan'),
      'GP': ('Crosstrek', 'SUV'),
      'GT': ('Crosstrek', 'SUV'),
      'BT': ('Outback', 'SUV'),
    };

    return modelMap[code] ?? (null, null);
  }
}
