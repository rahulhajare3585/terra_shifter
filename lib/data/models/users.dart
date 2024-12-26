import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String name;
  final String email;
  final String password;
  final String contactNumber;
  final String address;
  final DateTime dateOfBirth;

  Users({
    required this.name,
    required this.email,
    required this.password,
    required this.contactNumber,
    required this.address,
    required this.dateOfBirth,
  });

  factory Users.fromMap(Map<String, dynamic> data) {
    return Users(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      contactNumber: data['contactNumber'] ?? '',
      address: data['address'] ?? '',
      dateOfBirth: (data['dateOfBirth'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'contactNumber': contactNumber,
      'address': address,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
    };
  }
}