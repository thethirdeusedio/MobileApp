import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/service_plan.dart';
import '../repos/service_plan_repo.dart';

class ReadServicePlanById {
  final ServicePlanRepository servicePlanRepository;

  ReadServicePlanById(this.servicePlanRepository);

   Future<Either<Failure, ServicePlan?>> call(ServicePlan servicePLan) async =>
    await servicePlanRepository.readServicePlanById(servicePLan);
}

