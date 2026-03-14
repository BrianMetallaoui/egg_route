import 'package:drift/drift.dart';

import '../database/database.dart';
import '../models/customer.dart';

class CustomerRepository {
  final AppDatabase _db;
  CustomerRepository(this._db);

  Future<List<Customer>> getAll() async {
    final rows = await _db.select(_db.customers).get();
    return rows.map(_mapRow).toList();
  }

  Stream<List<Customer>> watchAll() {
    return _db
        .select(_db.customers)
        .watch()
        .map((rows) => rows.map(_mapRow).toList());
  }

  Future<Customer?> getById(String id) async {
    final row = await (_db.select(
      _db.customers,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row != null ? _mapRow(row) : null;
  }

  Future<void> insert(Customer customer) async {
    await _db
        .into(_db.customers)
        .insert(
          CustomersCompanion.insert(
            id: customer.id,
            name: customer.name,
            address: Value(customer.address),
            notes: Value(customer.notes),
            isActive: Value(customer.isActive),
          ),
        );
  }

  Future<void> updateCustomer(Customer customer) async {
    await (_db.update(
      _db.customers,
    )..where((t) => t.id.equals(customer.id))).write(
      CustomersCompanion(
        name: Value(customer.name),
        address: Value(customer.address),
        notes: Value(customer.notes),
        isActive: Value(customer.isActive),
      ),
    );
  }

  Future<void> deleteCustomer(String id) async {
    await (_db.delete(_db.customers)..where((t) => t.id.equals(id))).go();
  }

  Customer _mapRow(CustomerRow row) => Customer(
    id: row.id,
    name: row.name,
    address: row.address,
    notes: row.notes,
    isActive: row.isActive,
  );
}
