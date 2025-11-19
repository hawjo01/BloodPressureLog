class Record {
  int? id;
  DateTime date;
  int systolic;
  int diastolic;
  int heartRate;

  Record({this.id, required this.date, required this.systolic, required this.diastolic, required this.heartRate});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'systolic': systolic,
      'diastolic': diastolic,
      'heartRate': heartRate,
    };
  }

  factory Record.fromMap(Map<String, dynamic> map) {
    return Record(
      id: map['id'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      systolic: map['systolic'],
      diastolic: map['diastolic'],
      heartRate: map['heartRate'],
    );
  }

  @override
  String toString() {
    return 'Record{id: $id, date: $date, systolic: $systolic, diastolic: $diastolic, heartRate: $heartRate}';
  }
}