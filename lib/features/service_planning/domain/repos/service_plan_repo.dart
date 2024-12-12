import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/service_plan.dart';

abstract class ServicePlanRepository {
  Future<Either<Failure, void>> createServicePlan(ServicePlan servicePlan);
  Future<Either<Failure, List<ServicePlan>>> readAllServicePlans();
  Future<Either<Failure, ServicePlan?>> readServicePlanById(
      ServicePlan servicePlan);
  Future<Either<Failure, void>> updateServicePlan(ServicePlan servicePlan);
  Future<Either<Failure, void>> deleteServicePlan(ServicePlan servicePLan);
}
