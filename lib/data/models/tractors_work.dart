class TractorsWork {
   String id;
  final String customerId;
  final String machineType;
  final String workName;
  final String workDate;
  final String AreaOrQuantity;
  final String measurementUnit;
  final String amountPerUnit;
  final String totalWorkAmount;
  final String receivedAmount;

  TractorsWork({
    required this.id,
    required this.customerId,
    required this.machineType,
    required this.workName,
    required this.workDate,
    required this.AreaOrQuantity,
    required this.measurementUnit,
    required this.amountPerUnit,
    required this.totalWorkAmount,
    required this.receivedAmount,
  });

  factory TractorsWork.fromJson(Map<String, dynamic> json) {
    return TractorsWork(
      id: json['id'],
      customerId: json['customerId'],
      machineType: json['machineType'],
      workName: json['workName'],
      workDate: json['workDate'],
      AreaOrQuantity: json['AreaOrQuantity'],
      measurementUnit: json['measurementUnit'],
      amountPerUnit: json['amountPerUnit'],
      totalWorkAmount: json['totalWorkAmount'],
      receivedAmount: json['receivedAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'machineType': machineType,
      'workName': workName,
      'workDate': workDate,
      'AreaOrQuantity': AreaOrQuantity,
      'measurementUnit': measurementUnit,
      'amountPerUnit': amountPerUnit,
      'totalWorkAmount': totalWorkAmount,
      'receivedAmount': receivedAmount,
    };
  }
}