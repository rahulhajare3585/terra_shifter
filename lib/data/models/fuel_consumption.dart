import 'package:cloud_firestore/cloud_firestore.dart';

class FuelConsumption {
  final String id;
  final DateTime date;
  final String machineType;
  final double amountPerLitre;
  final double quantity;
  final double totalAmount;

  FuelConsumption({
    required this.id,
    required this.date,
    required this.machineType,
    required this.amountPerLitre,
    required this.quantity,
    required this.totalAmount,
  });

  factory FuelConsumption.fromMap(Map<String, dynamic> map) {
    return FuelConsumption(
      id: map['id'],
      date: (map['date'] as Timestamp).toDate(),
      machineType: map['machineType'],
      amountPerLitre: map['amountPerLitre'],
      quantity: map['quantity'],
      totalAmount: map['totalAmount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'machineType': machineType,
      'amountPerLitre': amountPerLitre,
      'quantity': quantity,
      'totalAmount': totalAmount,
    };
  }
}