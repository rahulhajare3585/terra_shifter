import 'package:equatable/equatable.dart';

abstract class JcbInvoiceEvent {
  const JcbInvoiceEvent();

  @override
  List<Object> get props => [];
}

class LoadJCBInvoice extends JcbInvoiceEvent {
  final String customerId;

  const LoadJCBInvoice(this.customerId);

  @override
  List<Object> get props => [customerId];
}

class FilterJCBInvoiceByDate extends JcbInvoiceEvent {
  final DateTime startDate;
  final DateTime endDate;

  const FilterJCBInvoiceByDate(this.startDate, this.endDate);

  @override
  List<Object> get props => [startDate, endDate];
}