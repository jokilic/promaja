import 'dart:convert';

class Main {
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;

  Main({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
  });

  Main copyWith({
    double? temp,
    double? feelsLike,
    double? tempMin,
    double? tempMax,
    int? pressure,
    int? humidity,
  }) =>
      Main(
        temp: temp ?? this.temp,
        feelsLike: feelsLike ?? this.feelsLike,
        tempMin: tempMin ?? this.tempMin,
        tempMax: tempMax ?? this.tempMax,
        pressure: pressure ?? this.pressure,
        humidity: humidity ?? this.humidity,
      );

  Map<String, dynamic> toMap() => {
        'temp': temp,
        'feels_like': feelsLike,
        'temp_min': tempMin,
        'temp_max': tempMax,
        'pressure': pressure,
        'humidity': humidity,
      };

  factory Main.fromMap(Map<String, dynamic> map) => Main(
        temp: map['temp']?.toDouble() ?? 0.0,
        feelsLike: map['feels_like']?.toDouble() ?? 0.0,
        tempMin: map['temp_min']?.toDouble() ?? 0.0,
        tempMax: map['temp_max']?.toDouble() ?? 0.0,
        pressure: map['pressure']?.toInt() ?? 0,
        humidity: map['humidity']?.toInt() ?? 0,
      );

  String toJson() => json.encode(toMap());

  factory Main.fromJson(String source) => Main.fromMap(json.decode(source));

  @override
  String toString() => 'Main(temp: $temp, feelsLike: $feelsLike, tempMin: $tempMin, tempMax: $tempMax, pressure: $pressure, humidity: $humidity)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Main &&
        other.temp == temp &&
        other.feelsLike == feelsLike &&
        other.tempMin == tempMin &&
        other.tempMax == tempMax &&
        other.pressure == pressure &&
        other.humidity == humidity;
  }

  @override
  int get hashCode => temp.hashCode ^ feelsLike.hashCode ^ tempMin.hashCode ^ tempMax.hashCode ^ pressure.hashCode ^ humidity.hashCode;
}
