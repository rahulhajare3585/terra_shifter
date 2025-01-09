import 'package:equatable/equatable.dart';
import 'package:terra_shifter/data/models/fuel_consumption.dart';

abstract class FuelConsumptionEvent extends Equatable {
  const FuelConsumptionEvent();

  @override
  List<Object> get props => [];
}

class LoadFuelConsumptions extends FuelConsumptionEvent {}

class AddFuelConsumption extends FuelConsumptionEvent {
  final FuelConsumption fuelConsumption;

  const AddFuelConsumption(this.fuelConsumption);

  @override
  List<Object> get props => [fuelConsumption];
}

class UpdateFuelConsumption extends FuelConsumptionEvent {
  final FuelConsumption fuelConsumption;

  const UpdateFuelConsumption(this.fuelConsumption);

  @override
  List<Object> get props => [fuelConsumption];
}

class DeleteFuelConsumption extends FuelConsumptionEvent {
  final String id;

  const DeleteFuelConsumption(this.id);

  @override
  List<Object> get props => [id];
}

class FilterFuelConsumptions extends FuelConsumptionEvent {
  final DateTime startDate;
  final DateTime endDate;
  final String machineType;

  const FilterFuelConsumptions(this.startDate, this.endDate, this.machineType);

  @override
  List<Object> get props => [startDate, endDate, machineType];
}