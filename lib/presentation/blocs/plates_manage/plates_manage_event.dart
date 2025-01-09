import 'package:equatable/equatable.dart';
import 'package:terra_shifter/data/models/plates_master.dart';

abstract class PlatesManageEvent extends Equatable {
  const PlatesManageEvent();

  @override
  List<Object> get props => [];
}

class AddPlateMasterEvent extends PlatesManageEvent {
  final PlatesMaster plateMaster;

  const AddPlateMasterEvent(this.plateMaster);

  @override
  List<Object> get props => [plateMaster];
}

class GetPlateMasterEvent extends PlatesManageEvent {
  final int id;

  const GetPlateMasterEvent(this.id);

  @override
  List<Object> get props => [id];
}

class GetAllPlateMastersEvent extends PlatesManageEvent {}

class UpdatePlateMasterEvent extends PlatesManageEvent {
  final PlatesMaster plateMaster;

  const UpdatePlateMasterEvent(this.plateMaster);

  @override
  List<Object> get props => [plateMaster];
}

class DeletePlateMasterEvent extends PlatesManageEvent {
  final int id;

  const DeletePlateMasterEvent(this.id);

  @override
  List<Object> get props => [id];
}

class GetAllCustomersEvent extends PlatesManageEvent {}
