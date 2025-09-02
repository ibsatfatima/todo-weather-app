import 'package:equatable/equatable.dart';
import '../data/todo_model.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();
  @override
  List<Object?> get props => [];
}
class TodoLoadRequested extends TodoEvent {}
class TodoAddRequested extends TodoEvent {
  final String title;
  final String description;
  const TodoAddRequested(this.title, this.description);
  @override
  List<Object?> get props => [title, description];
}
class TodoToggleRequested extends TodoEvent {
  final String id;
  const TodoToggleRequested(this.id);
  @override
  List<Object?> get props => [id];
}
class TodoDeleteRequested extends TodoEvent {
  final String id;
  const TodoDeleteRequested(this.id);
  @override
  List<Object?> get props => [id];
}
