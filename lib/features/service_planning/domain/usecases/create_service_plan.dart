import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/service_plan.dart';
import '../repos/service_plan_repo.dart';

class CreateServicePlan {
  final ServicePlanRepository servicePlanRepository;

  CreateServicePlan(this.servicePlanRepository);

  Future<Either<Failure, void>> call(ServicePlan servicePlan) {
    return servicePlanRepository.createServicePlan(servicePlan);
  }
}


