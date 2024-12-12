import 'package:church_service_planner/features/volunteer_coordination/domain/entities/volunteer_assignment.dart';

abstract class VolunteerAssignmentRemoteDataSource {
  Future<void> createVolunteerAssignment(VolunteerAssignment assignment);
  Future<List<VolunteerAssignment>> readAllVolunteerAssignments();
  Future<VolunteerAssignment?> readVolunteerAssignmentById(
      VolunteerAssignment assignment);
  Future<void> updateVolunteerAssignment(VolunteerAssignment assignment);
  Future<void> deleteVolunteerAssignment(VolunteerAssignment assignment);
}
