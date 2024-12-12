import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/volunteer_assignment.dart';
import '../repos/volunteer_assignment_repo.dart';

class ReadAllVolunteerAssignment {
  final VolunteerAssignmentRepository repository;

  ReadAllVolunteerAssignment(this.repository);

  Future<Either<Failure, List<VolunteerAssignment>>> call() async =>
    await repository.readAllVolunteerAssignments();
}