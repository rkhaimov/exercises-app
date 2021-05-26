import 'package:exesices_app/in_mem_storage.dart';
import 'package:exesices_app/state.dart';
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
  AppState appState = AppState(InMemoryTodoRepository());

  @override
  void initState() {
    super.initState();

    appState.onInit(setState);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
          appBar: AppBar(
            title: Text('Vanilla state'),
          ),
          body: appState.loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ReorderableListView.builder(
                  buildDefaultDragHandles: false,
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }

                      final todo = appState.todos.removeAt(oldIndex);

                      appState.todos.insert(newIndex, todo);
                    });
                  },
                  itemCount: appState.todos.length,
                  itemBuilder: (context, index) {
                    final todo = appState.todos[index];

                    return ListTile(
                      key: ValueKey(todo.id),
                      leading:
                          Checkbox(value: todo.completed, onChanged: (_) {}),
                      title: Text(todo.task,
                          style: Theme.of(context).textTheme.headline6),
                      subtitle: Text('Subtitle'),
                      trailing: ReorderableDragStartListener(
                          index: index, child: Icon(Icons.drag_handle)),
                    );
                  },
                )),
    );
  }
}
