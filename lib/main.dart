import 'package:exesices_app/models/todo/in_mem_storage.dart';
import 'package:exesices_app/models/todo/main.dart';
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

  @override
  void initState() {
    super.initState();

    model.loadAll(setState);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      routes: {
        kTodoListRoute: (_) => TodoList(
            model.loading,
            model.todos,
            (id, checked) => model.toggleChecked(id, checked, setState),
            (filter) => model.setFilter(filter, setState),
            model.filter),
        kCreateTodoRoute: (_) => CreateTodo(
              onTodoCreate: (title, completed) =>
                  model.create(title, completed, setState),
            )
      },
    );
  }
}
