import 'package:exesices_app/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getAll();
}
