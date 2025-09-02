import 'package:dio/dio.dart';
import '../../core/constants.dart';
import '../exceptions/api_exception.dart';

class WeatherApiService {
  final Dio _dio;
  WeatherApiService({Dio? dio}) : _dio = dio ?? Dio();

  Future<Map<String, dynamic>> fetchCurrentWeatherByCity(String city) async {
    if (owmApiKey.isEmpty) {
      throw ApiException('OpenWeatherMap API key is missing. Provide it via --dart-define=OWM_API_KEY=KEY');
    }
    final url = 'https://api.openweathermap.org/data/2.5/weather';
    try {
      final resp = await _dio.get(url, queryParameters: {
        'q': city,
        'appid': owmApiKey,
        'units': 'metric',
      });
      return resp.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ApiException(e.message ?? 'Network error');
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> fetchCurrentWeatherByCoords(double lat, double lon) async {
    if (owmApiKey.isEmpty) {
      throw ApiException('OpenWeatherMap API key is missing. Provide it via --dart-define=OWM_API_KEY=KEY');
    }
    final url = 'https://api.openweathermap.org/data/2.5/weather';
    try {
      final resp = await _dio.get(url, queryParameters: {
        'lat': lat,
        'lon': lon,
        'appid': owmApiKey,
        'units': 'metric',
      });
      return resp.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ApiException(e.message ?? 'Network error');
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
