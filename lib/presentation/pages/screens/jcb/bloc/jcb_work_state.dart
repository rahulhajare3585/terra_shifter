import 'package:equatable/equatable.dart';
import 'package:terra_shifter/data/models/customer.dart';
import 'package:terra_shifter/data/models/jcb_work.dart';

abstract class JcbWorkState extends Equatable {
  const JcbWorkState();

  @override
  List<Object> get props => [];
}

class JcbWorkLoading extends JcbWorkState {}

class JcbWorkLoaded extends JcbWorkState {
  final List<JcbWork> jcbWorks;

  const JcbWorkLoaded(this.jcbWorks);

  @override
  List<Object> get props => [jcbWorks];
}

class JcbWorkOperationSuccess extends JcbWorkState {
  final String message;

  const JcbWorkOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class JcbWorkError extends JcbWorkState {
  final String error;

  const JcbWorkError(this.error);

  @override
  List<Object> get props => [error];
}

class CustomerLoading extends JcbWorkState {}

class CustomerLoaded extends JcbWorkState {
  final List<Customer> customers;

  CustomerLoaded(this.customers);
}

class CustomerError extends JcbWorkState {
  final String error;

  CustomerError(this.error);
}