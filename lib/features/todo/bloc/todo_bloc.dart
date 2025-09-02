import 'package:flutter_bloc/flutter_bloc.dart';
import 'todo_event.dart';
import 'todo_state.dart';
import '../data/todo_repository.dart';
import '../data/todo_model.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository? repository;

  TodoBloc({this.repository}) : super(TodoInitial()) {
    on<TodoLoadRequested>(_onLoad);
    on<TodoAddRequested>(_onAdd);
    on<TodoToggleRequested>(_onToggle);
    on<TodoDeleteRequested>(_onDelete);
  }

  Future<TodoRepository> _ensureRepo() async {
    if (repository != null) return repository!;
    return await TodoRepository.init();
  }

  Future<void> _onLoad(TodoLoadRequested event, Emitter<TodoState> emit) async {
    emit(TodoLoadInProgress());
    try {
      final repo = await _ensureRepo();
      final todos = repo.loadAll();
      emit(TodoLoadSuccess(todos));
    } catch (e) {
      emit(TodoFailure(e.toString()));
    }
  }

  Future<void> _onAdd(TodoAddRequested event, Emitter<TodoState> emit) async {
    try {
      final repo = await _ensureRepo();
      await repo.add(event.title, event.description);
      final todos = repo.loadAll();
      emit(TodoLoadSuccess(todos));
    } catch (e) {
      emit(TodoFailure(e.toString()));
    }
  }

  Future<void> _onToggle(TodoToggleRequested event, Emitter<TodoState> emit) async {
    try {
      final repo = await _ensureRepo();
      final current = repo.loadAll();
      final idx = current.indexWhere((t) => t.id == event.id);
      if (idx == -1) throw Exception('Todo not found');
      final t = current[idx];
      final updated = t.copyWith(isDone: !t.isDone);
      await repo.update(updated);
      emit(TodoLoadSuccess(repo.loadAll()));
    } catch (e) {
      emit(TodoFailure(e.toString()));
    }
  }

  Future<void> _onDelete(TodoDeleteRequested event, Emitter<TodoState> emit) async {
    try {
      final repo = await _ensureRepo();
      await repo.delete(event.id);
      emit(TodoLoadSuccess(repo.loadAll()));
    } catch (e) {
      emit(TodoFailure(e.toString()));
    }
  }
}
