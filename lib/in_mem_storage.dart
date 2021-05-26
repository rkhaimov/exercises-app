import 'package:exesices_app/storage.dart';
import 'package:exesices_app/todo.dart';

class InMemoryTodoRepository extends TodoRepository {
  @override
  Future<List<Todo>> getAll() {
    return Future.delayed(Duration(milliseconds: 5000), () {
      return [
        Todo('0', 'task0', false),
        Todo('1', 'task1', false),
      ];
    });
  }
}