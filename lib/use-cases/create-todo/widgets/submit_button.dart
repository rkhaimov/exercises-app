import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onSubmit;

  const SubmitButton({required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text('create'.toUpperCase(),
          style: Theme.of(context).textTheme.button!.merge(
              TextStyle(color: Theme.of(context).colorScheme.onSecondary))),
      onPressed: this.onSubmit,
      style: ElevatedButton.styleFrom(
          primary: Theme.of(context).colorScheme.secondary,
          fixedSize: Size.fromHeight(48)),
    );
  }
}
