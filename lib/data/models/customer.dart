// models/customer.dart
class Customer {
  final String id;
  final String name;
  final String address;
  final String contactNumber;

  Customer({
    required this.id,
    required this.name,
    required this.address,
    required this.contactNumber,
  });

  // Convert a Customer object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'contactNumber': contactNumber,
    };
  }

  // Convert a Map to a Customer object
  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
    );
  }
}
