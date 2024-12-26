import 'package:terra_shifter/data/models/plates.dart';

abstract class PlatesEvent {
  const PlatesEvent();

  @override
  List<Object?> get props => [];
}

class AddPlateEvent extends PlatesEvent {
  final Plates plate;

  const AddPlateEvent(this.plate);

  @override
  List<Object?> get props => [plate];
}

class GetPlateEvent extends PlatesEvent {
  final String id;

  const GetPlateEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class GetAllPlatesEvent extends PlatesEvent {}

class UpdatePlateEvent extends PlatesEvent {
  final Plates plate;

  const UpdatePlateEvent(this.plate);

  @override
  List<Object?> get props => [plate];
}

class DeletePlateEvent extends PlatesEvent {
  final String id;

  const DeletePlateEvent(this.id);

  @override
  List<Object?> get props => [id];
}