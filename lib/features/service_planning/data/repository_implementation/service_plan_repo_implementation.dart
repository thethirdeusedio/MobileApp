import 'package:church_service_planner/core/errors/exceptions.dart';
import 'package:church_service_planner/core/errors/failure.dart';
import 'package:church_service_planner/features/service_planning/data/data_source/service_plan_remote_data_source.dart';
import 'package:church_service_planner/features/service_planning/domain/entities/service_plan.dart';
import 'package:church_service_planner/features/service_planning/domain/repos/service_plan_repo.dart';
import 'package:dartz/dartz.dart';

class ServicePlanRepositoryImplementation implements ServicePlanRepository {
  final ServicePlanRemoteDataSource _remoteDataSource;

  const ServicePlanRepositoryImplementation(this._remoteDataSource);

  @override
  Future<Either<Failure, void>> createServicePlan(ServicePlan servicePlan) async {
    try {
      await _remoteDataSource.createServicePlan(servicePlan);
      return Right(null); // Return a success response
    } on APIException catch (e) {
      return left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteServicePlan(ServicePlan servicePlan) async {
    try {
      await _remoteDataSource.deleteServicePlan(servicePlan);
      return Right(null); // Return a success response
    } on APIException catch (e) {
      return left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ServicePlan>>> readAllServicePlans() async {
    try {
      final servicePlans = await _remoteDataSource.readAllServicePlans();
      return Right(servicePlans);
    } on APIException catch (e) {
      return left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ServicePlan?>> readServicePlanById(ServicePlan servicePlan) async {
    try {
      final servicePlans = await _remoteDataSource.readServicePlanById(servicePlan);
      return Right(servicePlans);
    } on APIException catch (e) {
      return left(APIFailure(message: e.message, statusCode: e.statusCode)); 
    } on Exception catch (e) {
      return left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateServicePlan(ServicePlan servicePlan) async {
    try {
      await _remoteDataSource.updateServicePlan(servicePlan);
      return Right(null); // Return a success response
    } on APIException catch (e) {
      return left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return left(GeneralFailure(message: e.toString()));
    }
  }
}
