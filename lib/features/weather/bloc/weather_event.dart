import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
  @override
  List<Object?> get props => [];
}

class WeatherFetchByCity extends WeatherEvent {
  final String city;
  const WeatherFetchByCity(this.city);
  @override
  List<Object?> get props => [city];
}

class WeatherFetchByLocation extends WeatherEvent {}
