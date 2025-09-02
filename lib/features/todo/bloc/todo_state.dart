import 'package:equatable/equatable.dart';
import '../data/todo_model.dart';

abstract class TodoState extends Equatable {
  const TodoState();
  @override
  List<Object?> get props => [];
}

class TodoInitial extends TodoState {}
class TodoLoadInProgress extends TodoState {}
class TodoLoadSuccess extends TodoState {
  final List<Todo> todos;
  const TodoLoadSuccess(this.todos);
  @override
  List<Object?> get props => [todos];
}
class TodoFailure extends TodoState {
  final String message;
  const TodoFailure(this.message);
  @override
  List<Object?> get props => [message];
}
