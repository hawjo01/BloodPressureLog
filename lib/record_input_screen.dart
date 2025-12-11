import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'components/date_picker_input_field.dart';
import 'components/numeric_input_field.dart';
import 'components/time_picker_input_field.dart';
import 'db/record_repository.dart';
import 'db/record.dart';

class RecordInputScreen extends StatefulWidget {
  const RecordInputScreen({super.key});

  @override
  State<RecordInputScreen> createState() => _RecordInputScreenState();
}

class _RecordInputScreenState extends State<RecordInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _systolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();
  final TextEditingController _pulseController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int? _systolic;
  int? _diastolic;
  int? _pulse;
  late Future<Record?> _mostRecentRecord;

  @override
  void initState() {
    super.initState();
    _mostRecentRecord = RecordRepository().getMostRecentRecord();
  }

  void _updateDay(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _updateTime(TimeOfDay time) {
    setState(() {
      _selectedTime = time;
    });
  }

  void _updateSystolic(int value) {
    setState(() => _systolic = value);
  }

  void _updateDiastolic(int value) {
    setState(() => _diastolic = value);
  }

  void _updatePulse(int value) {
    setState(() => _pulse = value);
  }

  Future<void> _saveRecord() async {
    final recordRepository = RecordRepository();
    final record = Record(
      date: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      ),
      systolic: _systolic!,
      diastolic: _diastolic!,
      heartRate: _pulse!,
    );
    await recordRepository.insertRecord(record);

    // Reset form after saving
    setState(() {
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();

      _systolicController.clear();
      _diastolicController.clear();
      _pulseController.clear();
      _systolic = null;
      _diastolic = null;
      _pulse = null;
      _mostRecentRecord = RecordRepository().getMostRecentRecord();
    });
  }

  Card _buildInputCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: DatePickerInputField(
                      initialDate: _selectedDate,
                      onDateChanged: (date) => _updateDay(date),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TimePickerInputField(
                      initialTime: _selectedTime,
                      onTimeChanged: (time) => _updateTime(time),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  NumericInputField(
                    label: 'Systolic',
                    hint: 'e.g., 120',
                    onChange: _updateSystolic,
                    controller: _systolicController,
                  ),
                  const SizedBox(width: 16.0),
                  NumericInputField(
                    label: 'Diastolic',
                    hint: 'e.g., 80',
                    onChange: _updateDiastolic,
                    controller: _diastolicController,
                  ),
                  const SizedBox(width: 16.0),
                  NumericInputField(
                    label: 'Pulse',
                    hint: 'e.g., 70',
                    onChange: _updatePulse,
                    controller: _pulseController,
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton.extended(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _saveRecord();
                        WidgetsBinding.instance.focusManager.primaryFocus
                            ?.unfocus();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Record saved')),
                        );
                      }
                    },
                    tooltip: 'Save',
                    icon: const Icon(Icons.save),
                    label: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card _buildLatestRecordCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Text(
                'Lastest Record',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 10),
            FutureBuilder<Record?>(
              future: _mostRecentRecord,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Text('No records found.');
                } else {
                  final record = snapshot.data!;
                  // return Text("foobar");
                  return ListTile(
                    title: Text(
                      DateFormat('EEE, MMM d, y h:mm a').format(record.date),
                    ),
                    subtitle: Text(
                      'Systolic: ${record.systolic}, Diastolic: ${record.diastolic}, Pulse: ${record.heartRate}',
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  _buildInputCard(),
                  const SizedBox(height: 10.0),
                  _buildLatestRecordCard(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
}
