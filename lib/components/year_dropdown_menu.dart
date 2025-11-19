import 'package:flutter/material.dart';

class YearSelector extends StatefulWidget {

  const YearSelector({super.key, required this.onYearSelected});

  final ValueChanged<int> onYearSelected;

  @override
  State<YearSelector> createState() => _YearSelectorState();
}

class _YearSelectorState extends State<YearSelector> {
  
  final TextEditingController _yearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<int>(
      controller: _yearController,
      initialSelection: DateTime.now().year,
      label: const Text('Year'),
      dropdownMenuEntries: List.generate(10, (index) {
        final year = DateTime.now().year - index;
        return DropdownMenuEntry(value: year, label: year.toString());
      }),
      onSelected: (int? year) {
        if (year != null) {
          widget.onYearSelected(year);
        }
      },
    );
  }
}