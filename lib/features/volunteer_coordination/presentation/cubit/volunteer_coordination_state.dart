part of 'volunteer_coordination_cubit.dart';

sealed class VolunteerCoordinationState extends Equatable {
  const VolunteerCoordinationState();

  @override
  List<Object> get props => [];

  get message => null;
}

class VolunteerAssignmentInitial extends VolunteerCoordinationState {}

class VolunteerAssignmentLoading extends VolunteerCoordinationState {}

class VolunteerAssignmentLoaded extends VolunteerCoordinationState {
  final List<VolunteerAssignment> assignment;

  const VolunteerAssignmentLoaded(this.assignment);

  @override
  List<Object> get props => [assignment];
}

class VolunteerAssignmentCreated extends VolunteerCoordinationState {}

class VolunteerAssignmentDeleted extends VolunteerCoordinationState {}

class VolunteerAssignmentUpdated extends VolunteerCoordinationState {
  final VolunteerAssignment newVolunteerAssignment;

  const VolunteerAssignmentUpdated(this.newVolunteerAssignment);

  @override
  List<Object> get props => [newVolunteerAssignment];
}

class VolunteerAssignmentError extends VolunteerCoordinationState {
  @override
  final String message;

  const VolunteerAssignmentError(this.message);

  @override
  List<Object> get props => [message];
}
