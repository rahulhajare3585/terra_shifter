
import 'package:terra_shifter/data/models/plates.dart';

abstract class PlateDetailsState {
  const PlateDetailsState();

  @override
  List<Object?> get props => [];
}

class PlatesInitial extends PlateDetailsState {}

class PlatesLoading extends PlateDetailsState {}

class PlatesLoaded extends PlateDetailsState {
  final List<Plates> plates;

  const PlatesLoaded(this.plates);

  @override
  List<Object?> get props => [plates];
}

class PlatesOperationSuccess extends PlateDetailsState {
  final String message;

  const PlatesOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class PlatesError extends PlateDetailsState {
  final String error;

  const PlatesError(this.error);

  @override
  List<Object?> get props => [error];
}