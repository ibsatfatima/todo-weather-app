import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive/hive.dart';

import 'package:todo_weather_app/features/todo/data/todo_model.dart';
import 'package:todo_weather_app/features/todo/data/todo_repository.dart';

class _MockTodoBox extends Mock implements Box<Todo> {}

void main() {
  late _MockTodoBox box;
  late TodoRepository repo;

  setUpAll(() {
    registerFallbackValue(
      Todo(id: 'fallback', title: 't', description: 'd', isDone: false),
    );
  });

  setUp(() {
    box = _MockTodoBox();
    repo = TodoRepository.test(box);
  });

  group('TodoRepository - add', () {
    test('adds a todo with generated id and returns it', () async {
      // Arrange
      when(() => box.put(any(), any())).thenAnswer((_) async {});

      // Act
      final result = await repo.add('Buy milk', '2 packs of whole milk');

      // Assert
      expect(result.id, isNotEmpty);
      expect(result.title, 'Buy milk');
      expect(result.description, '2 packs of whole milk');
      expect(result.isDone, isFalse);

      verify(() => box.put(result.id, result)).called(1);
      verifyNoMoreInteractions(box);
    });

    test('loadAll returns todos from box.values', () {
      // Arrange
      final todo1 = Todo(id: '1', title: 'A', description: 'a', isDone: false);
      final todo2 = Todo(id: '2', title: 'B', description: 'b', isDone: true);
      when(() => box.values).thenReturn([todo1, todo2]);

      // Act
      final list = repo.loadAll();

      // Assert
      expect(list, hasLength(2));
      expect(list.first.title, 'A');
      verify(() => box.values).called(1);
      verifyNoMoreInteractions(box);
    });
  });

  group('TodoRepository - delete', () {
    test('deletes by id', () async {
      // Arrange
      when(() => box.delete('123')).thenAnswer((_) async {});

      // Act
      await repo.delete('123');

      // Assert
      verify(() => box.delete('123')).called(1);
      verifyNoMoreInteractions(box);
    });
  });

  group('TodoRepository - update (bonus)', () {
    test('updates existing todo', () async {
      // Arrange
      final t = Todo(id: '5', title: 'Old', description: 'Old', isDone: false);
      when(() => box.put(t.id, t)).thenAnswer((_) async {});

      // Act
      await repo.update(t);

      // Assert
      verify(() => box.put('5', t)).called(1);
      verifyNoMoreInteractions(box);
    });
  });
}
