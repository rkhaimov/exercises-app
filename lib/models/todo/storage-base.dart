import 'package:exesices_app/models/todo/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getAll();
}
