import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/volunteer_assignment.dart';

abstract class VolunteerAssignmentRepository {
  Future<Either<Failure, void>> createVolunteerAssignment(
      VolunteerAssignment assignment);
  Future<Either<Failure, List<VolunteerAssignment>>>
      readAllVolunteerAssignments();
  Future<Either<Failure, VolunteerAssignment?>> readVolunteerAssignmentById(
      VolunteerAssignment assignment);
  Future<Either<Failure, void>> updateVolunteerAssignment(
      VolunteerAssignment assignment);
  Future<Either<Failure, void>> deleteVolunteerAssignment(
      VolunteerAssignment assignment);
}
