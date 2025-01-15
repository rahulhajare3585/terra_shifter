import 'package:equatable/equatable.dart';
import 'package:terra_shifter/data/models/customer.dart';
import 'package:terra_shifter/data/models/jcb_work.dart';
import 'package:terra_shifter/data/models/tractors_work.dart';

abstract class JCBInvoiceState extends Equatable {
  const JCBInvoiceState();

  @override
  List<Object> get props => [];
}

class JCBInvoiceLoading extends JCBInvoiceState {}

class JCBInvoiceLoaded extends JCBInvoiceState {
  final Customer customer;
  final List<JcbWork> jcbWork;

  const JCBInvoiceLoaded(this.customer, this.jcbWork);

  @override
  List<Object> get props => [customer, jcbWork];
}

class JCBInvoiceError extends JCBInvoiceState {
  final String message;

  const JCBInvoiceError(this.message);

  @override
  List<Object> get props => [message];
}