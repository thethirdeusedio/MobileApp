import 'package:equatable/equatable.dart';

class VolunteerAssignment extends Equatable {
  final String id;
  final String role;
  final String volunteerName;
  final String date;
  final String serviceId; // Assuming this relates to the service plan

  const VolunteerAssignment({
    required this.id,
    required this.role,
    required this.volunteerName,
    required this.date,
    required this.serviceId,
  });

  @override
  List<Object> get props => [id];
}
