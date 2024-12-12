import 'package:church_service_planner/features/volunteer_coordination/domain/entities/volunteer_assignment.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repos/volunteer_assignment_repo.dart';

class DeleteVolunteerAssignment {
  final VolunteerAssignmentRepository repository;

  DeleteVolunteerAssignment(this.repository);

  Future<Either<Failure, void>> call(VolunteerAssignment assignment) async =>
    await repository.deleteVolunteerAssignment(assignment);
}
