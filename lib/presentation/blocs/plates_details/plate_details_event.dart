import 'package:terra_shifter/data/models/plates.dart';

abstract class PlateDetailsEvent {
  const PlateDetailsEvent();

  @override
  List<Object?> get props => [];
}

class AddPlateEvent extends PlateDetailsEvent {
  final Plates plate;

  const AddPlateEvent(this.plate);

  @override
  List<Object?> get props => [plate];
}

class GetPlateEvent extends PlateDetailsEvent {
  final String id;

  const GetPlateEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class GetAllPlatesEvent extends PlateDetailsEvent {}

class UpdatePlateEvent extends PlateDetailsEvent {
  final Plates plate;

  const UpdatePlateEvent(this.plate);

  @override
  List<Object?> get props => [plate];
}

class DeletePlateEvent extends PlateDetailsEvent {
  final String id;

  const DeletePlateEvent(this.id);

  @override
  List<Object?> get props => [id];
}