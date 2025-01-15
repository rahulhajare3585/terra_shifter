abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final double fuelTotal;
  final double jcbTotal;
  final double tractorTotal;
  final double platesTotal;

  HomeLoaded(this.fuelTotal, this.jcbTotal, this.tractorTotal, this.platesTotal);
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}