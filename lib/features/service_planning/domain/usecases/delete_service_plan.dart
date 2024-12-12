import 'package:church_service_planner/features/service_planning/domain/entities/service_plan.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repos/service_plan_repo.dart';

class DeleteServicePlan {
  final ServicePlanRepository servicePlanRepository;

  DeleteServicePlan(this.servicePlanRepository);

  Future<Either<Failure, void>> call(ServicePlan servicePLan) async =>
    await servicePlanRepository.deleteServicePlan(servicePLan);
}

