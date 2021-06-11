import 'package:exesices_app/models/todo/in_mem_storage.dart';
import 'package:exesices_app/models/todo/main.dart';
import 'package:exesices_app/typedefs.dart';
import 'package:exesices_app/use-cases/create-todo/constants.dart';
import 'package:exesices_app/use-cases/create-todo/main.dart';
import 'package:exesices_app/use-cases/todo-list/constants.dart';
import 'package:exesices_app/use-cases/todo-list/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(VanillaApp());
}

class VanillaApp extends StatefulWidget {
  @override
  _VanillaAppState createState() => _VanillaAppState();
}

class _VanillaAppState extends State<VanillaApp> {
  TodoModel model = TodoModel(InMemoryTodoRepository());
  AppTheme theme = AppTheme.dark;

  @override
  void initState() {
    super.initState();

    model.loadAll(setState);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme == AppTheme.light ? ThemeData.light() : ThemeData.dark(),
      routes: {
        kTodoListRoute: (_) => TodoList(
              loading: model.loading,
              todos: model.todos,
              filter: model.filter,
              theme: theme,
              onThemeChange: () => setState(() {
                theme =
                    theme == AppTheme.light ? AppTheme.dark : AppTheme.light;
              }),
              onTodoCheck: (id, checked) =>
                  model.toggleChecked(id, checked, setState),
              onFilterSelect: (filter) => model.setFilter(filter, setState),
              onTodoReorder: (oldIndex, newIndex) =>
                  model.reorder(oldIndex, newIndex, setState),
            ),
        kCreateTodoRoute: (_) => CreateTodo(
              onTodoCreate: (title, completed) =>
                  model.create(title, completed, setState),
            )
      },
    );
  }
}
