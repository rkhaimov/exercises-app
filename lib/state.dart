import 'package:exesices_app/storage.dart';
import 'package:exesices_app/todo.dart';

class AppState {
  TodoRepository _repository;
  List<Todo> _todos = [];
  bool _loading = true;

  AppState(TodoRepository repository) : _repository = repository;

  List<Todo> get todos => _todos;
  bool get loading => _loading;

  onInit(Mutate mutate) async {
    var todos = await _repository.getAll();

    mutate(() {
      _loading = false;
      _todos = todos;
    });
  }
}

typedef VoidCallback = void Function();
typedef Mutate = void Function(VoidCallback fn);
