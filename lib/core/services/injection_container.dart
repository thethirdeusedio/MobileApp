import 'package:church_service_planner/features/service_planning/data/repository_implementation/service_plan_repo_implementation.dart';
import 'package:church_service_planner/features/service_planning/domain/repos/service_plan_repo.dart';
import 'package:church_service_planner/features/service_planning/domain/usecases/create_service_plan.dart';
import 'package:church_service_planner/features/service_planning/domain/usecases/delete_service_plan.dart';
import 'package:church_service_planner/features/service_planning/domain/usecases/read_all_service_plan.dart';
import 'package:church_service_planner/features/service_planning/domain/usecases/read_service_plan_by_id.dart';
import 'package:church_service_planner/features/service_planning/domain/usecases/update_service_plan.dart';
import 'package:church_service_planner/features/service_planning/presentation/cubit/service_planning_cubit.dart';
import 'package:church_service_planner/features/volunteer_coordination/data/repository_implementation/volunteer_assignment_repo_implementation.dart';
import 'package:church_service_planner/features/volunteer_coordination/domain/repos/volunteer_assignment_repo.dart';
import 'package:church_service_planner/features/volunteer_coordination/domain/usecases/create_volunteer_assignment.dart';
import 'package:church_service_planner/features/volunteer_coordination/domain/usecases/delete_volunteer_assignment.dart';
import 'package:church_service_planner/features/volunteer_coordination/domain/usecases/read_all_volunteer_assignment.dart';
import 'package:church_service_planner/features/volunteer_coordination/domain/usecases/read_volunteer_assignment_by_id.dart';
import 'package:church_service_planner/features/volunteer_coordination/domain/usecases/update_volunteer_assignment.dart';
import 'package:church_service_planner/features/volunteer_coordination/presentation/cubit/volunteer_coordination_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../../features/service_planning/data/data_source/service_plan_firebase_datasourse.dart';
import '../../features/service_planning/data/data_source/service_plan_remote_data_source.dart';
import '../../features/volunteer_coordination/data/data_source/volunteer_assignment_firebase_datasource.dart';
import '../../features/volunteer_coordination/data/data_source/volunteer_assignment_remote_datasource.dart';

final serviceLocator = GetIt.instance;

//manage dependencies

Future<void> init() async {
  //feature #1 service_planning
  // Presentation Layer
  serviceLocator.registerFactory(() => ServicePlanCubit(serviceLocator(),
      serviceLocator(), serviceLocator(), serviceLocator(), serviceLocator()));
 
//Domain Layer
  serviceLocator
      .registerLazySingleton(() => CreateServicePlan(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => ReadServicePlanById(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => ReadAllServicePlans(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => UpdateServicePlan(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => DeleteServicePlan(serviceLocator()));

  //data layer
  serviceLocator.registerLazySingleton<ServicePlanRepository>(
      () => ServicePlanRepositoryImplementation(serviceLocator()));
  serviceLocator.registerLazySingleton<ServicePlanRemoteDataSource>(
      () => ServicePlanFirebaseDataSource(serviceLocator()));
  serviceLocator.registerLazySingleton(() => FirebaseFirestore.instance);

  //feature #2 volunteer_coordination
  // Presentation Layer
  serviceLocator.registerFactory(() => VolunteerAssignmentCubit(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator()));

//Domain Layer
  serviceLocator
      .registerLazySingleton(() => CreateVolunteerAssignment(serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => ReadVolunteerAssignmentById(serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => ReadAllVolunteerAssignment(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => UpdateVolunteerAssignment(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => DeleteVolunteerAssignment(serviceLocator()));

  //data layer
  serviceLocator.registerLazySingleton<VolunteerAssignmentRepository>(
      () => VolunteerAssignmentRepositoryImplementation(serviceLocator()));
  serviceLocator.registerLazySingleton<VolunteerAssignmentRemoteDataSource>(
      () => VolunteerAssignmentFirebaseDataSource(serviceLocator()));
}
