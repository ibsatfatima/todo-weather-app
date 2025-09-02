class WeatherModel {
  final String cityName;
  final double tempC;
  final String condition;
  final String icon;

  WeatherModel({required this.cityName, required this.tempC, required this.condition, required this.icon});

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final city = json['name'] as String? ?? '';
    final main = json['main'] as Map<String, dynamic>? ?? {};
    final weatherList = json['weather'] as List<dynamic>? ?? [];
    final weather = weatherList.isNotEmpty ? weatherList[0] as Map<String, dynamic> : {};
    return WeatherModel(
      cityName: city,
      tempC: (main['temp'] as num?)?.toDouble() ?? 0.0,
      condition: weather['main'] as String? ?? '',
      icon: weather['icon'] as String? ?? '01d',
    );
  }
}
