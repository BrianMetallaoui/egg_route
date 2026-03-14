import 'package:flutter_test/flutter_test.dart';
import 'package:egg_route/core/utils/id_generator.dart';

void main() {
  group('generateId', () {
    test('starts with the given prefix', () {
      final id = generateId('ord');
      expect(id, startsWith('ord-'));
    });

    test('produces unique IDs on rapid successive calls', () {
      final ids = List.generate(100, (_) => generateId('test'));
      final unique = ids.toSet();
      expect(unique.length, 100);
    });

    test('different prefixes produce different IDs', () {
      final custId = generateId('cust');
      final ordId = generateId('ord');
      expect(custId, startsWith('cust-'));
      expect(ordId, startsWith('ord-'));
      expect(custId, isNot(equals(ordId)));
    });

    test('format is prefix-timestamp-counter', () {
      final id = generateId('dp');
      final parts = id.split('-');
      expect(parts.length, 3);
      expect(parts[0], 'dp');
      expect(int.tryParse(parts[1]), isNotNull); // timestamp
      expect(int.tryParse(parts[2]), isNotNull); // counter
    });
  });
}
