import 'package:equatable/equatable.dart';
import 'package:terra_shifter/data/models/customer.dart';
import 'package:terra_shifter/data/models/tractors_work.dart';

abstract class TractorInvoiceState extends Equatable {
  const TractorInvoiceState();

  @override
  List<Object> get props => [];
}

class TractorInvoiceLoading extends TractorInvoiceState {}

class TractorInvoiceLoaded extends TractorInvoiceState {
  final Customer customer;
  final List<TractorsWork> tractorWorks;

  const TractorInvoiceLoaded(this.customer, this.tractorWorks);

  @override
  List<Object> get props => [customer, tractorWorks];
}

class TractorInvoiceError extends TractorInvoiceState {
  final String message;

  const TractorInvoiceError(this.message);

  @override
  List<Object> get props => [message];
}