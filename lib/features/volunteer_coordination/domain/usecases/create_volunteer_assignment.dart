import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/volunteer_assignment.dart';
import '../repos/volunteer_assignment_repo.dart';

class CreateVolunteerAssignment {
  final VolunteerAssignmentRepository repository;

  CreateVolunteerAssignment(this.repository);

  Future<Either<Failure, void>> call(VolunteerAssignment assignment) async =>
      await repository.createVolunteerAssignment(assignment);
}
