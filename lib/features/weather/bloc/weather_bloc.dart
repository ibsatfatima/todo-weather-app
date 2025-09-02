import 'package:flutter_bloc/flutter_bloc.dart';
import 'weather_event.dart';
import 'weather_state.dart';
import '../data/weather_repository.dart';
import 'package:geolocator/geolocator.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository repository;
  WeatherBloc({WeatherRepository? repository}) : repository = repository ?? WeatherRepository(), super(WeatherInitial()) {
    on<WeatherFetchByCity>(_onFetchByCity);
    on<WeatherFetchByLocation>(_onFetchByLocation);
  }

  Future<void> _onFetchByCity(WeatherFetchByCity event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    try {
      final model = await repository.fetchByCity(event.city);
      emit(WeatherLoadSuccess(model));
    } catch (e) {
      emit(WeatherFailure(e.toString()));
    }
  }

  Future<void> _onFetchByLocation(WeatherFetchByLocation event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    try {
      final perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        final p = await Geolocator.requestPermission();
        if (p == LocationPermission.denied || p == LocationPermission.deniedForever) {
          emit(const WeatherFailure('Location permission denied'));
          return;
        }
      }
      final pos = await Geolocator.getCurrentPosition();
      final model = await repository.fetchByCoords(pos.latitude, pos.longitude);
      emit(WeatherLoadSuccess(model));
    } catch (e) {
      emit(WeatherFailure(e.toString()));
    }
  }
}
