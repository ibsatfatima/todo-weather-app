import 'package:equatable/equatable.dart';
import '../data/weather_model.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();
  @override
  List<Object?> get props => [];
}
class WeatherInitial extends WeatherState {}
class WeatherLoading extends WeatherState {}
class WeatherLoadSuccess extends WeatherState {
  final WeatherModel model;
  const WeatherLoadSuccess(this.model);
  @override
  List<Object?> get props => [model];
}
class WeatherFailure extends WeatherState {
  final String message;
  const WeatherFailure(this.message);
  @override
  List<Object?> get props => [message];
}
