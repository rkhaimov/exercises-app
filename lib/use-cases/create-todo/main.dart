import 'package:exesices_app/use-cases/create-todo/widgets/form_field.dart';
import 'package:exesices_app/use-cases/create-todo/widgets/submit_button.dart';
import 'package:exesices_app/use-cases/create-todo/widgets/checked_field.dart';
import 'package:flutter/material.dart';

class CreateTodo extends StatefulWidget {
  final void Function(String task, bool completed) onTodoCreate;

  const CreateTodo({required this.onTodoCreate});

  @override
  _CreateTodoState createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  String _title = '';
  bool _completed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create TODO'),
      ),
      body: Form(
          key: _form,
          child: Column(
            children: [
              FormElement(
                child: TextFormField(
                  initialValue: _title,
                  onSaved: setTitle,
                  validator: isEmpty,
                  decoration:
                      new InputDecoration(labelText: 'What needs to be done?'),
                ),
              ),
              FormElement(
                  child: CheckedField(
                initialValue: _completed,
                onSaved: setCompleted,
                label: 'Completed',
              )),
              Expanded(
                  child: Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SubmitButton(
                    onSubmit: this.validateCreateTodo,
                  ),
                ),
              ))
            ],
          )),
    );
  }

  void setCompleted(completed) => _completed = completed ?? _completed;

  void setTitle(task) => _title = task ?? _title;

  void validateCreateTodo() {
    final utils = this._form.currentState!;

    if (utils.validate()) {
      utils.save();

      this.widget.onTodoCreate(_title, _completed);

      Navigator.pop(context);
    }
  }

  String? isEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }

    return null;
  }
}
