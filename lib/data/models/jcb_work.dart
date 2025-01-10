class JcbWork {
  final String id;
  final String customerId;
  final String WorkDate;
  final String WorkName;
  final String? WorkDescription;
  final String LastUnit;
  final String CurrentUnit;
  final String WorkHours;
  final String WorkAmount;
  final String totalWorkAmount;
  final String receivedAmount;

  JcbWork({
    required this.id,
    required this.customerId,
    required this.WorkDate,
    required this.WorkName,
    this.WorkDescription,
    required this.LastUnit,
    required this.CurrentUnit,
    required this.WorkHours,
    required this.WorkAmount,
    required this.totalWorkAmount,
    required this.receivedAmount,
  });

  factory JcbWork.fromJson(Map<String, dynamic> json) {
    return JcbWork(
      id: json['id'],
      customerId: json['customerId'],
      WorkDate: json['WorkDate'],
      WorkName: json['WorkName'],
      WorkDescription: json['WorkDescription'],
      LastUnit: json['LastUnit'],
      CurrentUnit: json['CurrentUnit'],
      WorkHours: json['WorkHours'],
      WorkAmount: json['WorkAmount'],
      totalWorkAmount: json['totalWorkAmount'],
      receivedAmount: json['receivedAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'WorkDate': WorkDate,
      'WorkName': WorkName,
      'WorkDescription': WorkDescription,
      'LastUnit': LastUnit,
      'CurrentUnit': CurrentUnit,
      'WorkHours': WorkHours,
      'WorkAmount': WorkAmount,
      'totalWorkAmount': totalWorkAmount,
      'receivedAmount': receivedAmount,
    };
  }
}