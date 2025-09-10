import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Simple Test Suite', () {
    test('Basic functionality test', () {
      expect(1 + 1, equals(2));
    });

    test('String test', () {
      expect('Wimi', equals('Wimi'));
    });

    test('Boolean test', () {
      expect(true, isTrue);
      expect(false, isFalse);
    });

    test('List test', () {
      final list = [1, 2, 3];
      expect(list.length, equals(3));
      expect(list.first, equals(1));
      expect(list.last, equals(3));
    });

    test('Map test', () {
      final map = {'name': 'Wimi', 'type': 'app'};
      expect(map['name'], equals('Wimi'));
      expect(map['type'], equals('app'));
    });
  });
}
