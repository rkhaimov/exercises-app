import 'package:flutter/material.dart';

class FormElement extends StatelessWidget {
  final Widget child;

  FormElement({required Widget child}) : child = child;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: child);
  }
}
