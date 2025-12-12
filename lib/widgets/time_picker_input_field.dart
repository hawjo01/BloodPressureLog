import 'package:flutter/material.dart';

class TimePickerInputField extends StatefulWidget {
  const TimePickerInputField({
    super.key,
    required this.initialTime,
    required this.onTimeChanged,
  });

  final TimeOfDay initialTime;
  final Function(TimeOfDay) onTimeChanged;

  @override
  State<TimePickerInputField> createState() => _TimePickerInputFieldState();
}

class _TimePickerInputFieldState extends State<TimePickerInputField> {
  TimeOfDay? _selectedTime;
  final TextEditingController _timeController = TextEditingController();
  
  @override
  void initState() {
    _selectedTime = widget.initialTime;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _timeController.text = _selectedTime != null
        ? _selectedTime!.format(context)
        : widget.initialTime.format(context);
    super.didChangeDependencies();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? widget.initialTime,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
      if (context.mounted) {
        _timeController.text = _selectedTime!.format(context);
      }
      widget.onTimeChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _timeController,
      readOnly: true, // Prevent direct text input
      decoration: InputDecoration(
        labelText: 'Time',
        hintText: 'HH:MM',
        suffixIcon: IconButton(
          icon: const Icon(Icons.access_time),
          onPressed: () => _selectTime(context),
        ),
        border: const OutlineInputBorder(),
      ),
      onTap: () => _selectTime(context), // Open picker on tap
    );
  }

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }
}
