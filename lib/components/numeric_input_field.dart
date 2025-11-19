import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericInputField extends StatelessWidget {
  const NumericInputField({
    super.key,
    required String label,
    required String hint,
    required dynamic Function(int) onChange,
    bool required = true,
    required TextEditingController controller,
  }) : _onChange = onChange, _hint = hint, _label = label, _required = required, _controller = controller;

  final String _label;
  final String _hint;
  final bool _required;
  final Function(int) _onChange;
  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.number, // Displays a numeric keyboard
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly, // Restricts input to digits only
        ],
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: _label,
          hintText: _hint,
        ),
        validator: (value) {
          if (_required && (value == null || value.isEmpty)) {
            return 'Required';
          }
          return null;
        },
        onSaved: (value) {
          if (value != null && value.isNotEmpty) {
          _onChange(int.parse(value));
          }
        },
      ),
    );
  }
}