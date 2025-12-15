import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerInputField extends StatefulWidget {
  const DatePickerInputField({
    super.key,
    required this.initialDate,
    required this.onDateChanged,
  });

  final DateTime initialDate;
  final Function(DateTime) onDateChanged;

  @override
  State<DatePickerInputField> createState() => _DatePickerInputFieldState();
}

class _DatePickerInputFieldState extends State<DatePickerInputField> {
  final TextEditingController _dateController = TextEditingController();
  late DateTime _selectedDate;

  @override
  void initState() {
    _selectedDate = widget.initialDate;
    _dateController.text = _formatDate(_selectedDate);
    super.initState();
  } 

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(_selectedDate);
      });
      widget.onDateChanged(picked);
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('MM-dd-yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _dateController,
      readOnly: true, // Prevent direct text input
      decoration: InputDecoration(
        labelText: 'Date',
        hintText: 'MM-DD-YYYY',
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context),
        ),
        border: const OutlineInputBorder(),
      ),
      onTap: () => _selectDate(context), // Open picker on tap
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }
}
