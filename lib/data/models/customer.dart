final class Customer {
  final String id;
  final String name;
  final String address;
  final String notes;
  final bool isActive;

  const Customer({
    required this.id,
    required this.name,
    this.address = '',
    this.notes = '',
    this.isActive = true,
  });

  Customer copyWith({
    String? name,
    String? address,
    String? notes,
    bool? isActive,
  }) => Customer(
    id: id,
    name: name ?? this.name,
    address: address ?? this.address,
    notes: notes ?? this.notes,
    isActive: isActive ?? this.isActive,
  );
}
