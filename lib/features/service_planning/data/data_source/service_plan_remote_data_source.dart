import 'package:church_service_planner/features/service_planning/domain/entities/service_plan.dart';

abstract class ServicePlanRemoteDataSource {
  Future<void> createServicePlan(ServicePlan servicePlan);
  Future<List<ServicePlan>> readAllServicePlans();
  Future<ServicePlan?> readServicePlanById(ServicePlan servicePlan);
  Future<void> updateServicePlan(ServicePlan servicePlan);
  Future<void> deleteServicePlan(ServicePlan servicePlan);
}
