
import 'package:terra_shifter/data/models/plates.dart';

abstract class PlatesState {
  const PlatesState();

  @override
  List<Object?> get props => [];
}

class PlatesInitial extends PlatesState {}

class PlatesLoading extends PlatesState {}

class PlatesLoaded extends PlatesState {
  final List<Plates> plates;

  const PlatesLoaded(this.plates);

  @override
  List<Object?> get props => [plates];
}

class PlatesOperationSuccess extends PlatesState {
  final String message;

  const PlatesOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class PlatesError extends PlatesState {
  final String error;

  const PlatesError(this.error);

  @override
  List<Object?> get props => [error];
}