import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../core/constants.dart';
import 'todo_model.dart';

class TodoRepository {
  final Box<Todo> _box;

  TodoRepository._(this._box);

  @visibleForTesting
  factory TodoRepository.test(Box<Todo> box) => TodoRepository._(box);

  static Future<TodoRepository> init() async {
    final box = Hive.box<Todo>(hiveTodosBox);
    return TodoRepository._(box);
  }

  List<Todo> loadAll() {
    return _box.values.toList();
  }

  Future<Todo> add(String title, String description) async {
    // Generate ID based on current timestamp
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final todo = Todo(
      id: id,
      title: title,
      description: description,
      isDone: false,
    );

    await _box.put(todo.id, todo);
    return todo;
  }

  Future<void> update(Todo todo) async {
    await _box.put(todo.id, todo);
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}
