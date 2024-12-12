import 'package:equatable/equatable.dart';

class ServicePlan extends Equatable {
  final String id;
  final String date;
  final String timeStart;
  final String timeEnd;
  final String location;
  final String serviceType;

  const ServicePlan({
    required this.id,
    required this.date,
    required this.timeStart,
    required this.timeEnd,
    required this.location,
    required this.serviceType,
  });

  @override
  List<Object> get props => [id];
}
