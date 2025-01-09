import 'package:equatable/equatable.dart';
import 'package:terra_shifter/data/models/fuel_consumption.dart';

abstract class FuelConsumptionState extends Equatable {
  const FuelConsumptionState();

  @override
  List<Object> get props => [];
}

class FuelConsumptionInitial extends FuelConsumptionState {}

class FuelConsumptionLoading extends FuelConsumptionState {}

class FuelConsumptionLoaded extends FuelConsumptionState {
  final List<FuelConsumption> fuelConsumptions;

  const FuelConsumptionLoaded(this.fuelConsumptions);

  @override
  List<Object> get props => [fuelConsumptions];
}

class FuelConsumptionError extends FuelConsumptionState {
  final String message;

  const FuelConsumptionError(this.message);

  @override
  List<Object> get props => [message];
}