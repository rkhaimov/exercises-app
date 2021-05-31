import 'package:exesices_app/models/todo/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final PopupMenuItemSelected<VisibilityFilter> onFilterSelect;
  final VisibilityFilter filter;

  FilterButton(this.onFilterSelect, this.filter);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<VisibilityFilter>(
      icon: Icon(Icons.filter_list),
      onSelected: this.onFilterSelect,
      itemBuilder: (context) => [
        RadioPopupMenuItem(VisibilityFilter.all, this.filter, Text('Show All')),
        RadioPopupMenuItem(
            VisibilityFilter.active, this.filter, Text('Show Active')),
        RadioPopupMenuItem(
            VisibilityFilter.completed, this.filter, Text('Show Completed')),
      ],
    );
  }
}

class RadioPopupMenuItem extends PopupMenuItem<VisibilityFilter> {
  const RadioPopupMenuItem(
      VisibilityFilter value, VisibilityFilter selected, Widget child)
      : super(child: child, value: value, enabled: value != selected);
}
