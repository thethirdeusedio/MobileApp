import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/volunteer_assignment.dart';
import '../../domain/usecases/create_volunteer_assignment.dart';
import '../../domain/usecases/delete_volunteer_assignment.dart';
import '../../domain/usecases/read_all_volunteer_assignment.dart';
import '../../domain/usecases/read_volunteer_assignment_by_id.dart';
import '../../domain/usecases/update_volunteer_assignment.dart';

part 'volunteer_coordination_state.dart';

const String noInternetErrorMessage =
    "Sync failed: Changes saved on your device and will sync once you're back online.";

class VolunteerAssignmentCubit extends Cubit<VolunteerCoordinationState> {
  final CreateVolunteerAssignment createVolunteerAssignmentUseCase;
  final DeleteVolunteerAssignment deleteVolunteerAssignmentUseCase;
  final UpdateVolunteerAssignment updateVolunteerAssignmentUseCase;
  final ReadAllVolunteerAssignment readAllVolunteerAssignmentUseCase;
  final ReadVolunteerAssignmentById readVolunteerAssignmentByIdUseCase;

  VolunteerAssignmentCubit(
    this.createVolunteerAssignmentUseCase,
    this.deleteVolunteerAssignmentUseCase,
    this.updateVolunteerAssignmentUseCase,
    this.readAllVolunteerAssignmentUseCase,
    this.readVolunteerAssignmentByIdUseCase,
  ) : super(VolunteerAssignmentInitial());

//Read All Volunteer Assignment
  Future<void> readAllVolunteerAssignment() async {
    emit(VolunteerAssignmentLoading());

    try {
      final result = await readAllVolunteerAssignmentUseCase().timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request timed out"));
      result.fold(
        (failure) => emit(VolunteerAssignmentError(failure.message)),
        (assignments) {
          emit(VolunteerAssignmentLoaded(assignments));
        },
      );
    } on TimeoutException catch (_) {
      emit(VolunteerAssignmentError(
          "There seems to be a problem with your internet connection"));
    }
  }

//Read Volunteer Assignment by Id
  Future<void> readVolunteerAssignmentById(
      VolunteerAssignment assignment) async {
    // Emit loading state
    emit(VolunteerAssignmentLoading());

    try {
      // Call the read use case
      final Either<Failure, VolunteerAssignment?> result =
          await readVolunteerAssignmentByIdUseCase.call(assignment).timeout(
              const Duration(seconds: 10),
              onTimeout: () => throw TimeoutException("Request timed out"));
      // Handle the result
      result.fold(
        (failure) => emit(
            VolunteerAssignmentError(failure.getMessage())), // Handle failure
        (assignment) {
          emit(VolunteerAssignmentLoaded(
              assignment != null ? [assignment] : []));
        },
      );
    } on TimeoutException catch (_) {
      emit(VolunteerAssignmentError(
          "There seems to be a problem with your internet connection"));
    }
  }

//Create Volunteer Assignment
  Future<void> createAssignment(VolunteerAssignment assignment) async {
    try {
      final result = await createVolunteerAssignmentUseCase
          .call(assignment)
          .timeout(const Duration(seconds: 10),
              onTimeout: () => throw TimeoutException("Request timed out"));

      result.fold(
        (failure) => emit(VolunteerAssignmentError(failure.getMessage())),
        (_) {
          emit(VolunteerAssignmentCreated());
        },
      );
    } on TimeoutException catch (_) {
      emit(VolunteerAssignmentError(noInternetErrorMessage));
    }
  }

//Update Volunteer Assignment
  Future<void> updateAssignment(VolunteerAssignment assignment) async {
    try {
      final result = await updateVolunteerAssignmentUseCase
          .call(assignment)
          .timeout(const Duration(seconds: 10),
              onTimeout: () => throw TimeoutException("Request timed out"));

      result.fold(
        (failure) => emit(VolunteerAssignmentError(failure.message)),
        (_) {
          emit(VolunteerAssignmentUpdated(assignment));
        },
      );
    } on TimeoutException catch (_) {
      emit(VolunteerAssignmentError(noInternetErrorMessage));
    }
  }

//Delete Volunteer Assignment
  Future<void> deleteAssignment(VolunteerAssignment assignment) async {
    try {
      final Either<Failure, void> result =
          await deleteVolunteerAssignmentUseCase.call(assignment).timeout(
              const Duration(seconds: 10),
              onTimeout: () => throw TimeoutException("Request timed out"));

      result.fold(
        (failure) => emit(VolunteerAssignmentError(failure.getMessage())),
        (_) {
          emit(VolunteerAssignmentDeleted());
        },
      );
    } on TimeoutException catch (_) {
      emit(VolunteerAssignmentError(noInternetErrorMessage));
    }
  }
}
