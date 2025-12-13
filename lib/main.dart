import 'package:bp_pulse_log/history_chart_screen.dart';
import 'package:bp_pulse_log/record_input_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BloodPressureLogApp());
}

class BloodPressureLogApp extends StatelessWidget {
  const BloodPressureLogApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BP & Pulse Log',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const InputScreen(title: 'Blood Pressure & Pulse Log'),
    );
  }
}

class InputScreen extends StatefulWidget {
  const InputScreen({super.key, required this.title});

  final String title;

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  @override
  void initState() {
    super.initState();
  }

  int currentPageIndex = 0;
  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.alwaysShow;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (currentPageIndex) {
      case 0:
        page = RecordInputScreen();
        break;
      case 1:
        page = HistoryChartScreen();
        break;
      default:
        throw UnimplementedError('no widget for page index $currentPageIndex');
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: NavigationBar(
        labelBehavior: labelBehavior,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.note_add),
             label: 'Record',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'History',
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(child: page),
    );
  }
}