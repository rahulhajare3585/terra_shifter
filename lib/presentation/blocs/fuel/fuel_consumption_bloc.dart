import 'package:bloc/bloc.dart';
import 'package:terra_shifter/data/Services/fuel_consumption_service.dart';
import 'package:terra_shifter/data/models/fuel_consumption.dart';
import 'package:terra_shifter/presentation/blocs/fuel/fuel_consumption_event.dart';
import 'package:terra_shifter/presentation/blocs/fuel/fuel_consumption_state.dart';

class FuelConsumptionBloc extends Bloc<FuelConsumptionEvent, FuelConsumptionState> {
  final FuelConsumptionService fuelConsumptionService;

  FuelConsumptionBloc(this.fuelConsumptionService) : super(FuelConsumptionInitial()) {
    on<LoadFuelConsumptions>((event, emit) async {
      emit(FuelConsumptionLoading());
      try {
        final fuelConsumptions = await fuelConsumptionService.getAllFuelConsumptions();
        emit(FuelConsumptionLoaded(fuelConsumptions));
      } catch (e) {
        emit(FuelConsumptionError("Failed to load fuel consumptions: ${e.toString()}"));
      }
    });

    on<AddFuelConsumption>((event, emit) async {
      emit(FuelConsumptionLoading());
      try {
        await fuelConsumptionService.addFuelConsumption(event.fuelConsumption);
        final fuelConsumptions = await fuelConsumptionService.getAllFuelConsumptions();
        emit(FuelConsumptionLoaded(fuelConsumptions));
      } catch (e) {
        emit(FuelConsumptionError("Failed to add fuel consumption: ${e.toString()}"));
      }
    });

    on<UpdateFuelConsumption>((event, emit) async {
      emit(FuelConsumptionLoading());
      try {
        await fuelConsumptionService.updateFuelConsumption(event.fuelConsumption);
        final fuelConsumptions = await fuelConsumptionService.getAllFuelConsumptions();
        emit(FuelConsumptionLoaded(fuelConsumptions));
      } catch (e) {
        emit(FuelConsumptionError("Failed to update fuel consumption: ${e.toString()}"));
      }
    });

    on<DeleteFuelConsumption>((event, emit) async {
      emit(FuelConsumptionLoading());
      try {
        await fuelConsumptionService.deleteFuelConsumption(event.id);
        final fuelConsumptions = await fuelConsumptionService.getAllFuelConsumptions();
        emit(FuelConsumptionLoaded(fuelConsumptions));
      } catch (e) {
        emit(FuelConsumptionError("Failed to delete fuel consumption: ${e.toString()}"));
      }
    });

    on<FilterFuelConsumptions>((event, emit) async {
      emit(FuelConsumptionLoading());
      try {
        final allFuelConsumptions = await fuelConsumptionService.getAllFuelConsumptions();
        final filteredFuelConsumptions = allFuelConsumptions.where((fuelConsumption) {
          return fuelConsumption.date.isAfter(event.startDate) &&
              fuelConsumption.date.isBefore(event.endDate) &&
              fuelConsumption.machineType == event.machineType;
        }).toList();
        emit(FuelConsumptionLoaded(filteredFuelConsumptions));
      } catch (e) {
        emit(FuelConsumptionError("Failed to filter fuel consumptions: ${e.toString()}"));
      }
    });
  }
}