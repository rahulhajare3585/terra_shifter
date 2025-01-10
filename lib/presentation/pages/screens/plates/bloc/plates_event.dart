

import 'package:terra_shifter/presentation/pages/screens/plates/model/plates.dart';

abstract class PlatesEvent{
  const PlatesEvent();

  @override
  List<Object> get props => [];
}

class GetAllPlatesEvent extends PlatesEvent {}

class AddPlatesEvent extends PlatesEvent {
  final PlatesModel plates;

  const AddPlatesEvent(this.plates);

  @override
  List<Object> get props => [plates];
}

class UpdatePlatesEvent extends PlatesEvent {
  final PlatesModel plates;

  const UpdatePlatesEvent(this.plates);

  @override
  List<Object> get props => [plates];
}

class ResetPlatesEvent extends PlatesEvent {}