import 'package:church_service_planner/core/errors/exceptions.dart';
import 'package:church_service_planner/core/errors/failure.dart';
import 'package:church_service_planner/features/volunteer_coordination/data/data_source/volunteer_assignment_remote_datasource.dart';
import 'package:church_service_planner/features/volunteer_coordination/domain/entities/volunteer_assignment.dart';
import 'package:church_service_planner/features/volunteer_coordination/domain/repos/volunteer_assignment_repo.dart';
import 'package:dartz/dartz.dart';

class VolunteerAssignmentRepositoryImplementation
    implements VolunteerAssignmentRepository {
  final VolunteerAssignmentRemoteDataSource _remoteDataSource;

  const VolunteerAssignmentRepositoryImplementation(this._remoteDataSource);
  @override
  Future<Either<Failure, void>> createVolunteerAssignment(
      VolunteerAssignment assignment) async {
    try {
      return Right(
          await _remoteDataSource.createVolunteerAssignment(assignment));
    } on APIException catch (e) {
      return left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteVolunteerAssignment(VolunteerAssignment assignment) async {
    try {
      return Right(await _remoteDataSource.deleteVolunteerAssignment(assignment));
    } on APIException catch (e) {
      return left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VolunteerAssignment>>>
      readAllVolunteerAssignments() async {
    try {
      return Right(await _remoteDataSource.readAllVolunteerAssignments());
    } on APIException catch (e) {
      return left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, VolunteerAssignment?>> readVolunteerAssignmentById(
      VolunteerAssignment assignment) async {
    try {
      return Right(await _remoteDataSource.readVolunteerAssignmentById(assignment));
    } on APIException catch (e) {
      return left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateVolunteerAssignment(
      VolunteerAssignment assignment) async {
    try {
      return Right(await _remoteDataSource
          .updateVolunteerAssignment(assignment));
    } on APIException catch (e) {
      return left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return left(GeneralFailure(message: e.toString()));
    }
  }
}
