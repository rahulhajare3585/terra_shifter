class Plates {
  final String id;
  final String customerName;
  final String contactNumber;
  final DateTime givenDate;
  final DateTime receivedDate;
  final int totalDays;
  final int quantity;
  final double amountPerMonth;
  final double totalAmount;
  final double receivedAmount;
  final double pendingAmount;

  Plates({
    required this.id,
    required this.customerName,
    required this.contactNumber,
    required this.givenDate,
    required this.receivedDate,
    required this.totalDays,
    required this.quantity,
    required this.amountPerMonth,
    required this.totalAmount,
    required this.receivedAmount,
    required this.pendingAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'contactNumber': contactNumber,
      'givenDate': givenDate.toIso8601String(),
      'receivedDate': receivedDate.toIso8601String(),
      'totalDays': totalDays,
      'quantity': quantity,
      'amountPerMonth': amountPerMonth,
      'totalAmount': totalAmount,
      'receivedAmount': receivedAmount,
      'pendingAmount': pendingAmount,
    };
  }

  factory Plates.fromMap(Map<String, dynamic> map) {
    return Plates(
      id: map['id'],
      customerName: map['customerName'],
      contactNumber: map['contactNumber'],
      givenDate: DateTime.parse(map['givenDate']),
      receivedDate: DateTime.parse(map['receivedDate']),
      totalDays: map['totalDays'],
      quantity: map['quantity'],
      amountPerMonth: map['amountPerMonth'],
      totalAmount: map['totalAmount'],
      receivedAmount: map['receivedAmount'],
      pendingAmount: map['pendingAmount'],
    );
  }
}