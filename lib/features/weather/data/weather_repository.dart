import '../../../core/services/weather_api_service.dart';
import 'weather_model.dart';

class WeatherRepository {
  final WeatherApiService api;
  WeatherRepository({WeatherApiService? api}) : api = api ?? WeatherApiService();

  Future<WeatherModel> fetchByCity(String city) async {
    final json = await api.fetchCurrentWeatherByCity(city);
    return WeatherModel.fromJson(json);
  }

  Future<WeatherModel> fetchByCoords(double lat, double lon) async {
    final json = await api.fetchCurrentWeatherByCoords(lat, lon);
    return WeatherModel.fromJson(json);
  }
}
