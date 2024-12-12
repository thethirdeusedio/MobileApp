import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/service_plan.dart';
import '../repos/service_plan_repo.dart';

class ReadAllServicePlans {
  final ServicePlanRepository servicePlanRepository;

  ReadAllServicePlans(this.servicePlanRepository);

  Future<Either<Failure, List<ServicePlan>>> call() async =>
    await servicePlanRepository.readAllServicePlans();
}

