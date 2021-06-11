import 'package:exesices_app/models/todo/main.dart';
import 'package:exesices_app/models/todo/todo.dart';
import 'package:exesices_app/typedefs.dart';
import 'package:exesices_app/use-cases/create-todo/constants.dart';
import 'package:exesices_app/use-cases/todo-list/widgets/filter_button.dart';
import 'package:flutter/material.dart';

class TodoList extends StatelessWidget {
  final bool loading;
  final List<Todo> todos;
  final void Function(String id, bool checked) onTodoCheck;
  final void Function(int oldIndex, int newIndex) onTodoReorder;
  final void Function() onThemeChange;
  final AppTheme theme;
  final PopupMenuItemSelected<VisibilityFilter> onFilterSelect;
  final VisibilityFilter filter;

  TodoList(
      {required this.loading,
      required this.todos,
      required this.onTodoCheck,
      required this.onFilterSelect,
      required this.onTodoReorder,
      required this.onThemeChange,
      required this.theme,
      required this.filter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vanilla state'),
        actions: [FilterButton(this.onFilterSelect, this.filter)],
      ),
      drawer: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              'Preferences',
              style: Theme.of(context).textTheme.headline6!.merge(
                  TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
            ),
          ),
          ListTile(
            title: Text(
              'Dark mode',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            trailing: Switch(
              value: theme == AppTheme.dark,
              onChanged: (_) => onThemeChange(),
            ),
            onTap: onThemeChange,
          ),
        ]),
      ),
      body: loading ? buildProgress() : buildTodosList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).pushNamed(kCreateTodoRoute),
      ),
    );
  }

  ReorderableListView buildTodosList() {
    return ReorderableListView.builder(
      onReorder: onTodoReorder,
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];

        return CheckboxListTile(
          value: todo.completed,
          onChanged: (checked) => onTodoCheck(todo.id, checked as bool),
          key: ValueKey(todo.id),
          title: Text(todo.task, style: Theme.of(context).textTheme.subtitle1),
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
