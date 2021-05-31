import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onSubmit;

  const SubmitButton({required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        'create'.toUpperCase(),
        style: TextStyle(
            fontSize: 16, color: Theme.of(context).colorScheme.primaryVariant),
      ),
      onPressed: this.onSubmit,
      style: ElevatedButton.styleFrom(
          primary: Theme.of(context).colorScheme.secondary,
          fixedSize: Size.fromHeight(48)),
    );
  }
}
