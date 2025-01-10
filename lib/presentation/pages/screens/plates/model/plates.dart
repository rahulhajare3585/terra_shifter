class PlatesModel {
  final int id;
  final int customerId;
  final int givenPlates;
  final String amountPer100Plates;
  final String givenDate;
  final int? receivedPlates;
  final String? receivedDate;

  PlatesModel({
    required this.id,
    required this.customerId,
    required this.givenPlates,
    required this.amountPer100Plates,
    required this.givenDate,
    this.receivedPlates,
    this.receivedDate,
  });

  // Convert a PlatesModel object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'givenPlates': givenPlates,
      'amountPer100Plates': amountPer100Plates,
      'givenDate': givenDate,
      'receivedPlates': receivedPlates,
      'receivedDate': receivedDate,
    };
  }

  // Convert a Map to a PlatesModel object
  factory PlatesModel.fromMap(Map<String, dynamic> map) {
    return PlatesModel(
      id: map['id'] ?? 0,
      customerId: map['customerId'] ?? 0,
      givenPlates: map['givenPlates'] ?? 0,
      amountPer100Plates: map['amountPer100Plates'] ?? '',
      givenDate: map['givenDate'] ?? '',
      receivedPlates: map['receivedPlates'] ?? 0,
      receivedDate: map['receivedDate'] ?? '',
    );
  }
}
