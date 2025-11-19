import 'package:flutter/material.dart';

enum MonthLabel {
  january('January', 1),
  february('February', 2),
  march('March', 3),
  april('April', 4),
  may('May', 5),
  june('June', 6),
  july('July', 7),
  august('August', 8),
  september('September', 9),
  october('October', 10),
  november('November', 11),
  december('December', 12);

  const MonthLabel(this.label, this.number);

  final String label;
  final int number;

  static MonthLabel getByNumber(int monthNumber) {
    return MonthLabel.values.firstWhere((month) => month.number == monthNumber);
  }
}

typedef MonthEntry = DropdownMenuEntry<MonthLabel>;

class MonthSelector extends StatefulWidget {

  const MonthSelector({super.key, required this.onMonthSelected});

  final ValueChanged<int> onMonthSelected;

  @override
  State<MonthSelector> createState() => _MonthSelectorState();
}

class _MonthSelectorState extends State<MonthSelector> {
  
  final TextEditingController _monthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<MonthLabel>(
      controller: _monthController,
      initialSelection: MonthLabel.getByNumber(DateTime.now().month),
      label: const Text('Month'),
      dropdownMenuEntries: MonthLabel.values.map((month) {
        return MonthEntry(
          value: month,
          label: month.name[0].toUpperCase() + month.name.substring(1),
        );
      }).toList(),
      onSelected: (MonthLabel? month) {
        if (month != null) {
          widget.onMonthSelected(month.number);
        }
      },
    );
  }
}