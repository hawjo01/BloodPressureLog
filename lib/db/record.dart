class Record {
  int? id;
  DateTime date;
  int systolic;
  int diastolic;
  int pulse;

  Record({this.id, required this.date, required this.systolic, required this.diastolic, required this.pulse});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'systolic': systolic,
      'diastolic': diastolic,
      'pulse': pulse,
    };
  }

  factory Record.fromMap(Map<String, dynamic> map) {
    return Record(
      id: map['id'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      systolic: map['systolic'],
      diastolic: map['diastolic'],
      pulse: map['pulse'],
    );
  }

  @override
  String toString() {
    return 'Record{id: $id, date: $date, systolic: $systolic, diastolic: $diastolic, pulse: $pulse}';
  }
}