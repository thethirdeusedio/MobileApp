import 'dart:async';

import 'package:church_service_planner/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/service_plan.dart';
import '../../domain/usecases/create_service_plan.dart';
import '../../domain/usecases/delete_service_plan.dart';
import '../../domain/usecases/read_all_service_plan.dart';
import '../../domain/usecases/read_service_plan_by_id.dart';
import '../../domain/usecases/update_service_plan.dart';

part 'service_planning_state.dart';

const String noInternetErrorMessage =
    "Sync failed: Changes saved on your device and will sync once you're back online.";

class ServicePlanCubit extends Cubit<ServicePlanningState> {
  final CreateServicePlan createServicePlanUseCase;
  final ReadAllServicePlans readAllServicePlansUseCase;
  final ReadServicePlanById readServicePlanByIdUseCase;
  final UpdateServicePlan updateServicePlanUseCase;
  final DeleteServicePlan deleteServicePlanUseCase;

  ServicePlanCubit(
    this.createServicePlanUseCase,
    this.readAllServicePlansUseCase,
    this.readServicePlanByIdUseCase,
    this.updateServicePlanUseCase,
    this.deleteServicePlanUseCase,
  ) : super(ServicePlanningInitial());

  // Fetch all service plans
  Future<void> readAllServicePlans() async {
    emit(ServicePlanningLoading());

    try {
      final result = await readAllServicePlansUseCase().timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request timed out"));
      result.fold(
        (failure) => emit(ServicePlanningError(failure.message)),
        (servicePlans) {
          emit(ServicePlanningLoaded(servicePlans));
        },
      );
    } on TimeoutException catch (_) {
      emit(ServicePlanningError(
          "There seems to be a problem with your internet connection"));
    }
  }

  Future<void> readServicePlanById(ServicePlan servicePlan) async {
    // Emit loading state
    emit(ServicePlanningLoading());

    try {
      // Call the read use case
      final result = await readServicePlanByIdUseCase.call(servicePlan).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request timed out"));
      // Handle the result
      result.fold(
        (failure) =>
            emit(ServicePlanningError(failure.message)), // Handle failure
        (servicePlans) {
          // If the servicePlan is not null, wrap it in a list; otherwise, pass an empty list
          emit(ServicePlanningLoaded(
              servicePlans != null ? [servicePlans] : []));
        },
      );
    } on TimeoutException catch (_) {
      emit(ServicePlanningError(
          "There seems to be a problem with your internet connection"));
    }
  }

  // Create a new service plan
  Future<void> createServicePlan(ServicePlan servicePlan) async {
    emit(ServicePlanningLoading());

    try {
      final result = await createServicePlanUseCase.call(servicePlan).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request timed out"));
      result.fold(
        (failure) => emit(ServicePlanningError(failure.message)),
        (_) {
          emit(ServicePlanCreated());
        },
      );
    } on TimeoutException catch (_) {
      emit(ServicePlanningError(""));
    }
  }

  // Update an existing service plan
  Future<void> updateExistingServicePlan(ServicePlan servicePlan) async {
    emit(ServicePlanningLoading());

    try {
      final Either<Failure, void> result = await updateServicePlanUseCase
          .call(servicePlan)
          .timeout(const Duration(seconds: 10),
              onTimeout: () => throw TimeoutException("Request timed out"));

      result.fold(
        (failure) => emit(ServicePlanningError(failure.message)),
        (_) {
          emit(ServicePlanUpdated(servicePlan));
        },
      );
    } on TimeoutException catch (_) {
      emit(ServicePlanningError(""));
    }
  }

  // Delete a service plan
  Future<void> deleteServicePlan(ServicePlan servicePlan) async {
    emit(ServicePlanningLoading());

    try {
      final Either<Failure, void> result = await deleteServicePlanUseCase
          .call(servicePlan)
          .timeout(const Duration(seconds: 10),
              onTimeout: () => throw TimeoutException("Request timed out"));

      result.fold(
        (failure) => emit(ServicePlanningError(failure.message)),
        (_) {
          emit(ServicePlanDeleted());
        },
      );
    } on TimeoutException catch (_) {
      emit(ServicePlanningError(""));
    }
  }
}
