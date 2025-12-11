import 'package:flutter/material.dart';

class YearDropdownMenu extends StatefulWidget {
  const YearDropdownMenu({
    super.key,
    required this.initialValue,
    required this.years,
    required this.onYearChanged,
  });

  final int initialValue;
  final List<int> years;
  final ValueChanged<int> onYearChanged;

  @override
  State<YearDropdownMenu> createState() => _YearDropdownMenuState();
}

class _YearDropdownMenuState extends State<YearDropdownMenu> {
  final TextEditingController _yearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<int>(
      controller: _yearController,
      initialSelection: widget.initialValue,
      label: const Text('Year'),
      dropdownMenuEntries: widget.years.map((year) {
        return DropdownMenuEntry(value: year, label: year.toString());
      }).toList(),
      onSelected: (int? year) {
        if (year != null) {
          widget.onYearChanged(year);
        }
      },
    );
  }
}
