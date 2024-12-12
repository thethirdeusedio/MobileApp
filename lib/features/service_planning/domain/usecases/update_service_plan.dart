import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/service_plan.dart';
import '../repos/service_plan_repo.dart';

class UpdateServicePlan {
  final ServicePlanRepository servicePlanRepository;

  UpdateServicePlan(this.servicePlanRepository);

  Future<Either<Failure, void>> call(ServicePlan servicePlan) async =>
    await servicePlanRepository.updateServicePlan(servicePlan);
}

