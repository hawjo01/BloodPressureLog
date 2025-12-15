import 'package:bp_pulse_log/utils/datetime_utils.dart' as utils;
import 'package:test/test.dart';

void main() {
  group('DateTimeUtils Tests', () {
    test('isDameDay - sameDay', () {
      final date1 = DateTime(2024, 6, 15, 10, 30);
      final date2 = DateTime(2024, 6, 15, 22, 45);
      expect(utils.DateTimeUtils.isSameDay(date1, date2), isTrue);
    });

    test('isDameDay - different day', () {
      final date1 = DateTime(2024, 6, 14, 10, 30);
      final date2 = DateTime(2024, 6, 15, 22, 45);
      expect(utils.DateTimeUtils.isSameDay(date1, date2), isFalse);
    });

    test('isDameDay - different month', () {
      final date1 = DateTime(2024, 5, 15, 10, 30);
      final date2 = DateTime(2024, 6, 15, 22, 45);
      expect(utils.DateTimeUtils.isSameDay(date1, date2), isFalse);
    });

    test('isDameDay - different year', () {
      final date1 = DateTime(2024, 5, 5, 10, 30);
      final date2 = DateTime(2025, 5, 15, 22, 45);
      expect(utils.DateTimeUtils.isSameDay(date1, date2), isFalse);
    });
  });
}
