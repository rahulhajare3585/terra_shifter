class TractorsWork {
  final String id;
  final String customerId;
  final String machineType;
  final String workName;
  final String workDate;
  final String AreaOrQuantity;
  final String amountPerUnit;
  final String totalWorkAmount;

  TractorsWork({
    required this.id,
    required this.customerId,
    required this.machineType,
    required this.workName,
    required this.workDate,
    required this.AreaOrQuantity,
    required this.amountPerUnit,
    required this.totalWorkAmount,
  });

  factory TractorsWork.fromJson(Map<String, dynamic> json) {
    return TractorsWork(
      id: json['id'],
      customerId: json['customerId'],
      machineType: json['machineType'],
      workName: json['workName'],
      workDate: json['workDate'],
      AreaOrQuantity: json['AreaOrQuantity'],
      amountPerUnit: json['amountPerUnit'],
      totalWorkAmount: json['totalWorkAmount'],
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
      'amountPerUnit': amountPerUnit,
      'totalWorkAmount': totalWorkAmount,
    };
  }
}