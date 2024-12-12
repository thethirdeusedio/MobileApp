part of 'service_planning_cubit.dart';

abstract class ServicePlanningState extends Equatable {
  const ServicePlanningState();

  @override
  List<Object> get props => [];

  get message => null;
}

class ServicePlanningInitial extends ServicePlanningState {}

class ServicePlanningLoading extends ServicePlanningState {}

class ServicePlanningLoaded extends ServicePlanningState {
  final List<ServicePlan> servicePlans;

  const ServicePlanningLoaded(this.servicePlans);

  @override
  List<Object> get props => [servicePlans];
}

class ServicePlanCreated extends ServicePlanningState {}

class ServicePlanDeleted extends ServicePlanningState {}

class ServicePlanUpdated extends ServicePlanningState {
  final ServicePlan newServicePlan;

  const ServicePlanUpdated(this.newServicePlan);

  @override
  List<Object> get props => [newServicePlan];
}

class ServicePlanningError extends ServicePlanningState {
  @override
  final String message;

  const ServicePlanningError(this.message);

  @override
  List<Object> get props => [message];
}
