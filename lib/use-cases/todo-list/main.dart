import 'package:exesices_app/models/todo/main.dart';
import 'package:exesices_app/models/todo/todo.dart';
import 'package:exesices_app/use-cases/create-todo/constants.dart';
import 'package:exesices_app/use-cases/todo-list/widgets/filter_button.dart';
import 'package:flutter/material.dart';

class TodoList extends StatelessWidget {
  final bool loading;
  final List<Todo> todos;
  final void Function(String id, bool checked) onTodoCheck;
  final PopupMenuItemSelected<VisibilityFilter> onFilterSelect;
  final VisibilityFilter filter;

  TodoList(this.loading, this.todos, this.onTodoCheck, this.onFilterSelect,
      this.filter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vanilla state'),
        actions: [FilterButton(this.onFilterSelect, this.filter)],
      ),
      body: loading ? buildProgress() : buildTodosList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).pushNamed(kCreateTodoRoute),
      ),
    );
  }

  ListView buildTodosList() {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];

        return CheckboxListTile(
          value: todo.completed,
          onChanged: (checked) => onTodoCheck(todo.id, checked as bool),
          key: ValueKey(todo.id),
          title: Text(todo.task, style: Theme.of(context).textTheme.headline6),
        );
      },
    );
  }

  Center buildProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
