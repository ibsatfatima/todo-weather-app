import 'package:dio/dio.dart';
import '../../core/constants.dart';
import '../exceptions/api_exception.dart';

class WeatherApiService {
  final Dio _dio;

  WeatherApiService({Dio? dio}) : _dio = dio ?? Dio();

  Future<Map<String, dynamic>> fetchCurrentWeatherByCity(String city) async {
    if (owmApiKey.isEmpty) {
      throw ApiException(
        'OpenWeatherMap API key is missing.',
      );
    }
    final url = 'https://api.openweathermap.org/data/2.5/weather';
    try {
      final resp = await _dio.get(
        url,
        queryParameters: {'q': city, 'appid': owmApiKey, 'units': 'metric'},
      );
      // print('🌍 API Request (City): $url?q=$city&appid=$owmApiKey&units=metric');
      print('API Response (City): ${resp.data}');
      return resp.data as Map<String, dynamic>;
    } on DioException catch (e) {
      print('API Error (City): ${e.message}');
      throw ApiException(e.message ?? 'Network error');
    } catch (e) {
      print('Unexpected Error (City): $e');
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> fetchCurrentWeatherByCoords(
    double lat,
    double lon,
  ) async {
    if (owmApiKey.isEmpty) {
      throw ApiException(
        'OpenWeatherMap API key is missing.',
      );
    }
    final url = 'https://api.openweathermap.org/data/2.5/weather';
    try {
      final resp = await _dio.get(
        url,
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': owmApiKey,
          'units': 'metric',
        },
      );
      // print('🌍 API Request (Coords): $url?lat=$lat&lon=$lon&appid=$owmApiKey&units=metric');
      print('API Response (Coords): ${resp.data}');
      return resp.data as Map<String, dynamic>;
    } on DioException catch (e) {
      print('API Error (Coords): ${e.message}');
      throw ApiException(e.message ?? 'Network error');
    } catch (e) {
      print('Unexpected Error (Coords): $e');
      throw ApiException(e.toString());
    }
  }
}
