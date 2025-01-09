import 'package:equatable/equatable.dart';

abstract class TractorInvoiceEvent extends Equatable {
  const TractorInvoiceEvent();

  @override
  List<Object> get props => [];
}

class LoadTractorInvoice extends TractorInvoiceEvent {
  final String customerId;

  const LoadTractorInvoice(this.customerId);

  @override
  List<Object> get props => [customerId];
}

class FilterTractorInvoiceByDate extends TractorInvoiceEvent {
  final DateTime startDate;
  final DateTime endDate;

  const FilterTractorInvoiceByDate(this.startDate, this.endDate);

  @override
  List<Object> get props => [startDate, endDate];
}