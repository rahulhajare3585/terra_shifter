import 'package:equatable/equatable.dart';
import 'package:terra_shifter/data/models/customer.dart';
import 'package:terra_shifter/data/models/tractors_work.dart';

abstract class TractorsWorkState extends Equatable {
  const TractorsWorkState();

  @override
  List<Object> get props => [];
}

class CustomerLoading extends TractorsWorkState {}

class CustomerLoaded extends TractorsWorkState {
  final List<Customer> customers;

  CustomerLoaded(this.customers);
}
class TractorsWorkInitial extends TractorsWorkState {}

class TractorsWorkLoading extends TractorsWorkState {}

class TractorsWorkLoaded extends TractorsWorkState {
  final List<TractorsWork> tractorsWorks;

  const TractorsWorkLoaded(this.tractorsWorks);

  @override
  List<Object> get props => [tractorsWorks];
}

class TractorsWorkOperationSuccess extends TractorsWorkState {
  final String message;

  const TractorsWorkOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class TractorsWorkError extends TractorsWorkState {
  final String error;

  const TractorsWorkError(this.error);

  @override
  List<Object> get props => [error];
}

class CustomerError extends TractorsWorkState {
  final String error;

  CustomerError(this.error);
}