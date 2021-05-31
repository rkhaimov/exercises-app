import 'package:flutter/material.dart';

class CheckedField extends FormField<bool> {
  final String label;
  final FormFieldSetter<bool> onSaved;
  final bool? initialValue;

  CheckedField(
      {this.initialValue, required this.label, required this.onSaved})
      : super(
            initialValue: initialValue,
            onSaved: onSaved,
            builder: (FormFieldState<bool> field) {
              final value = field.value ?? false;

              return InkWell(
                onTap: () {
                  return field.didChange(!value);
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(label),
                      Switch(value: value, onChanged: field.didChange)
                    ]),
              );
            });
}
