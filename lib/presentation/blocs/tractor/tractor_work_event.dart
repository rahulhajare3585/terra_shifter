import 'package:equatable/equatable.dart';
import 'package:terra_shifter/data/models/tractors_work.dart';

abstract class TractorsWorkEvent extends Equatable {
  const TractorsWorkEvent();

  @override
  List<Object> get props => [];
}


class GetTractorsWorkByCustomerIdEvent extends TractorsWorkEvent {
  final String customerId;
  const GetTractorsWorkByCustomerIdEvent(this.customerId);
  @override
  List<Object> get props => [customerId];
}

class AddTractorsWorkEvent extends TractorsWorkEvent {
  final TractorsWork tractorsWork;

  const AddTractorsWorkEvent(this.tractorsWork);

  @override
  List<Object> get props => [tractorsWork];
}

class GetTractorsWorkEvent extends TractorsWorkEvent {
  final String id;

  const GetTractorsWorkEvent(this.id);

  @override
  List<Object> get props => [id];
}

class GetAllTractorsWorksEvent extends TractorsWorkEvent {}

class UpdateTractorsWorkEvent extends TractorsWorkEvent {
  final TractorsWork tractorsWork;

  const UpdateTractorsWorkEvent(this.tractorsWork);

  @override
  List<Object> get props => [tractorsWork];
}

class GetAllCustomersEvent extends TractorsWorkEvent {}

class DeleteTractorsWorkEvent extends TractorsWorkEvent {
  final String id;

  const DeleteTractorsWorkEvent(this.id);

  @override
  List<Object> get props => [id];
}