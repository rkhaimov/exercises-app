import 'package:exesices_app/models/todo/storage-base.dart';
import 'package:exesices_app/models/todo/todo.dart';

class TodoModel {
  TodoRepository _repository;
  List<Todo> _todos = [];
  bool _loading = true;
  VisibilityFilter _filter = VisibilityFilter.all;

  TodoModel(TodoRepository repository) : _repository = repository;

  VisibilityFilter get filter => _filter;

  List<Todo> get todos {
    if (_filter == VisibilityFilter.active) {
      return _todos.where((element) => element.completed == false).toList();
    }

    if (_filter == VisibilityFilter.completed) {
      return _todos.where((element) => element.completed).toList();
    }

    return _todos;
  }

  bool get loading => _loading;

  loadAll(Mutate mutate) async {
    var todos = await _repository.getAll();

    mutate(() {
      _loading = false;
      _todos = todos;
    });
  }

  toggleChecked(String id, bool checked, Mutate mutate) {
    var target = _todos.singleWhere((element) => element.id == id);

    mutate(() {
      target.completed = checked;
    });
  }

  setFilter(VisibilityFilter filter, Mutate mutate) {
    mutate(() {
      this._filter = filter;
    });
  }

  create(String title, bool completed, Mutate mutate) {
    mutate(() {
      _todos.add(Todo(title, title, completed));
    });
  }
}

typedef VoidCallback = void Function();
typedef Mutate = void Function(VoidCallback fn);

enum VisibilityFilter { all, active, completed }
