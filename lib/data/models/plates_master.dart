class PlatesMaster {
  final int id;
  String? plateNumber;
  final int totalPlates = 600;
  final int reservedPlates;
  final int availablePlates;
  final String customerId;
  final String customerName;
  final String givenPlatesQuantity;
  final String givenDate;
  String? receivedDate;
  String? receivedPlatesQuantity;

  PlatesMaster({
    required this.id,
    this.plateNumber,
    required this.reservedPlates,
    required this.availablePlates,
    required this.customerId,
    required this.customerName,
    required this.givenPlatesQuantity,
    required this.givenDate,
    this.receivedDate,
    this.receivedPlatesQuantity,
  });

  PlatesMaster copyWith({
    int? id,
    String? plateNumber,
    int? reservedPlates,
    int? availablePlates,
    String? customerId,
    String? customerName,
    String? givenPlatesQuantity,
    String? givenDate,
    String? receivedDate,
    String? receivedPlatesQuantity,
  }) {
    return PlatesMaster(
      id: id ?? this.id,
      plateNumber: plateNumber ?? this.plateNumber,
      reservedPlates: reservedPlates ?? this.reservedPlates,
      availablePlates: availablePlates ?? this.availablePlates,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      givenPlatesQuantity: givenPlatesQuantity ?? this.givenPlatesQuantity,
      givenDate: givenDate ?? this.givenDate,
      receivedDate: receivedDate ?? this.receivedDate,
      receivedPlatesQuantity: receivedPlatesQuantity ?? this.receivedPlatesQuantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plateNumber': plateNumber,
      'reservedPlates': reservedPlates,
      'availablePlates': availablePlates,
      'customerId': customerId,
      'customerName': customerName,
      'givenPlatesQuantity': givenPlatesQuantity,
      'givenDate': givenDate,
      'receivedDate': receivedDate,
      'receivedPlatesQuantity': receivedPlatesQuantity,
    };
  }

  factory PlatesMaster.fromMap(Map<String, dynamic> map) {
    return PlatesMaster(
      id: map['id'],
      plateNumber: map['plateNumber'],
      reservedPlates: map['reservedPlates'],
      availablePlates: map['availablePlates'],
      customerId: map['customerId'],
      customerName: map['customerName'],
      givenPlatesQuantity: map['givenPlatesQuantity'],
      givenDate: map['givenDate'],
      receivedDate: map['receivedDate'],
      receivedPlatesQuantity: map['receivedPlatesQuantity'],
    );
  }
}