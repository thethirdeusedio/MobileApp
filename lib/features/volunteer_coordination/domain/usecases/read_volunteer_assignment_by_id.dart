import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/volunteer_assignment.dart';
import '../repos/volunteer_assignment_repo.dart';

class ReadVolunteerAssignmentById {
  final VolunteerAssignmentRepository repository;

  ReadVolunteerAssignmentById(this.repository);

  Future<Either<Failure, VolunteerAssignment?>> call(
          VolunteerAssignment assignment) async =>
      await repository.readVolunteerAssignmentById(assignment);
}
