import 'package:exesices_app/models/todo/storage-base.dart';
import 'package:exesices_app/models/todo/todo.dart';

class InMemoryTodoRepository extends TodoRepository {
  @override
  Future<List<Todo>> getAll() {
    return Future.value([
      Todo('0', 'task0', false),
      Todo('1', 'task1', false),
    ]);
  }
}