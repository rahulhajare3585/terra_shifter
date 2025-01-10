import 'package:equatable/equatable.dart';
import 'package:terra_shifter/data/models/jcb_work.dart';

abstract class JcbWorkEvent extends Equatable {
  const JcbWorkEvent();

  @override
  List<Object> get props => [];
}

class GetAllJcbWorksEvent extends JcbWorkEvent {}

class AddJcbWorkEvent extends JcbWorkEvent {
  final JcbWork jcbWork;

  const AddJcbWorkEvent(this.jcbWork);

  @override
  List<Object> get props => [jcbWork];
}

class UpdateJcbWorkEvent extends JcbWorkEvent {
  final JcbWork jcbWork;

  const UpdateJcbWorkEvent(this.jcbWork);

  @override
  List<Object> get props => [jcbWork];
}

class GetAllCustomersEvent extends JcbWorkEvent {}