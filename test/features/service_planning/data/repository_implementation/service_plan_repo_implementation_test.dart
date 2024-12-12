import 'package:church_service_planner/core/errors/exceptions.dart';
import 'package:church_service_planner/core/errors/failure.dart';
import 'package:church_service_planner/features/service_planning/data/data_source/service_plan_remote_data_source.dart';
import 'package:church_service_planner/features/service_planning/data/repository_implementation/service_plan_repo_implementation.dart';
import 'package:church_service_planner/features/service_planning/domain/entities/service_plan.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

// Mock class for the data source
class MockServicePlanRemoteDataSource extends Mock
    implements ServicePlanRemoteDataSource {}

void main() {
  late ServicePlanRepositoryImplementation servicePlanRepositoryUnderTest;
  late MockServicePlanRemoteDataSource mockServicePlanRemoteDataSource;

  setUp(() {
    mockServicePlanRemoteDataSource = MockServicePlanRemoteDataSource();
    servicePlanRepositoryUnderTest =
        ServicePlanRepositoryImplementation(mockServicePlanRemoteDataSource);
  });

  final tServicePlan = ServicePlan(
    id: '1',
    date: 'November 23, 2024',
    timeStart: '10:00 AM',
    timeEnd: '11:00 AM',
    location: 'Church Hall',
    serviceType: 'Worship',
  );

  group('createServicePlan', () {
    test('should return Right(null) when creation succeeds', () async {
      // Arrange
      when(() =>
              mockServicePlanRemoteDataSource.createServicePlan(tServicePlan))
          .thenAnswer((_) async => Future.value());

      // Act
      final result =
          await servicePlanRepositoryUnderTest.createServicePlan(tServicePlan);

      // Assert
      expect(result, equals(const Right(null)));
      verify(() =>
              mockServicePlanRemoteDataSource.createServicePlan(tServicePlan))
          .called(1);
      verifyNoMoreInteractions(mockServicePlanRemoteDataSource);
    });

    test('should return Left(Failure) when creation fails', () async {
      // Arrange
      when(() =>
              mockServicePlanRemoteDataSource.createServicePlan(tServicePlan))
          .thenThrow(Exception('Something went wrong'));

      // Act
      final result =
          await servicePlanRepositoryUnderTest.createServicePlan(tServicePlan);

      // Assert
      expect(result, isA<Left<Failure, void>>());
      verify(() =>
              mockServicePlanRemoteDataSource.createServicePlan(tServicePlan))
          .called(1);
      verifyNoMoreInteractions(mockServicePlanRemoteDataSource);
    });
  });

  group('deleteServicePlan', () {
    // Define a test ServicePlan object
    final tServicePlan = ServicePlan(
      id: '1',
      date: 'November 23, 2024',
      timeStart: '10:00 AM',
      timeEnd: '11:00 AM',
      location: 'Community Center',
      serviceType: 'Prayer Meeting',
    );

    test('should return Right(void) when delete is successful', () async {
      // Arrange
      when(() =>
              mockServicePlanRemoteDataSource.deleteServicePlan(tServicePlan))
          .thenAnswer((_) async => Future.value());

      // Act
      final result =
          await servicePlanRepositoryUnderTest.deleteServicePlan(tServicePlan);

      // Assert
      expect(result, const Right(null)); // Right(void)
      verify(() =>
              mockServicePlanRemoteDataSource.deleteServicePlan(tServicePlan))
          .called(1);
      verifyNoMoreInteractions(mockServicePlanRemoteDataSource);
    });

    test('should return Left(Failure) when delete fails', () async {
      // Arrange
      when(() =>
              mockServicePlanRemoteDataSource.deleteServicePlan(tServicePlan))
          .thenThrow(Exception());

      // Act
      final result =
          await servicePlanRepositoryUnderTest.deleteServicePlan(tServicePlan);

      // Assert
      expect(result, isA<Left<Failure, void>>());
      verify(() =>
              mockServicePlanRemoteDataSource.deleteServicePlan(tServicePlan))
          .called(1);
      verifyNoMoreInteractions(mockServicePlanRemoteDataSource);
    });
  });

  final tServicePlans = [tServicePlan];
  group('readAllServicePlans', () {
    test('should return a list of ServicePlans when the call is successful',
        () async {
      // Arrange
      when(() => mockServicePlanRemoteDataSource.readAllServicePlans())
          .thenAnswer((_) async => tServicePlans);

      // Act
      final result = await servicePlanRepositoryUnderTest.readAllServicePlans();

      // Assert
      expect(result, equals(Right(tServicePlans)));
      verify(() => mockServicePlanRemoteDataSource.readAllServicePlans())
          .called(1);
      verifyNoMoreInteractions(mockServicePlanRemoteDataSource);
    });

    test('should return a Failure when the call throws an exception', () async {
      // Arrange
      when(() => mockServicePlanRemoteDataSource.readAllServicePlans())
          .thenThrow(const APIException(
              message: "Something went wrong with the server",
              statusCode: '500'));

      // Act
      final result = await servicePlanRepositoryUnderTest.readAllServicePlans();

      // Assert
      expect(result, isA<Left<Failure, List<ServicePlan>>>());
      verify(() => mockServicePlanRemoteDataSource.readAllServicePlans())
          .called(1);
      verifyNoMoreInteractions(mockServicePlanRemoteDataSource);
    });
  });

  group('readServicePlanById', () {
    const id = '123';
    final servicePlan = ServicePlan(
      id: id,
      date: 'November 23, 2024',
      timeStart: '10:00 AM',
      timeEnd: '11:00 AM',
      location: 'Main Hall',
      serviceType: 'Worship',
    );

    test('should return a ServicePlan when the call succeeds', () async {
      // Arrange
      when(() =>
              mockServicePlanRemoteDataSource.readServicePlanById(servicePlan))
          .thenAnswer((_) async => servicePlan);

      // Act
      final result =
          await servicePlanRepositoryUnderTest.readServicePlanById(servicePlan);

      // Assert
      expect(result, Right(servicePlan));
    });

    test('should return a Failure when the call fails', () async {
      // Arrange
      when(() =>
              mockServicePlanRemoteDataSource.readServicePlanById(servicePlan))
          .thenThrow(Exception('Service plan not found'));

      // Act
      final result =
          await servicePlanRepositoryUnderTest.readServicePlanById(servicePlan);

      // Assert
      expect(result, isA<Left<Failure, ServicePlan?>>());
    });
  });

  group('updateServicePlan', () {
    final tServicePlan = ServicePlan(
      id: '1',
      date: 'November 23, 2024',
      timeStart: '10:00 AM',
      timeEnd: '11:00 AM',
      location: 'Church Hall',
      serviceType: 'Sunday Service',
    );

    test('should return success when update is successful', () async {
      // Arrange
      when(() =>
              mockServicePlanRemoteDataSource.updateServicePlan(tServicePlan))
          .thenAnswer((_) async => Future.value());

      // Act
      final result =
          await servicePlanRepositoryUnderTest.updateServicePlan(tServicePlan);

      // Assert
      expect(result, Right(null)); // Expect Right(null) for a void response.
      verify(() =>
              mockServicePlanRemoteDataSource.updateServicePlan(tServicePlan))
          .called(1);
      verifyNoMoreInteractions(mockServicePlanRemoteDataSource);
    });

    test('should return failure when update fails', () async {
      // Arrange
      when(() =>
              mockServicePlanRemoteDataSource.updateServicePlan(tServicePlan))
          .thenThrow(APIException(
        message: 'Failed to update',
        statusCode: '500',
      ));

      // Act
      final result =
          await servicePlanRepositoryUnderTest.updateServicePlan(tServicePlan);

      // Assert
      expect(result, isA<Left<Failure, void>>());
      verify(() =>
              mockServicePlanRemoteDataSource.updateServicePlan(tServicePlan))
          .called(1);
      verifyNoMoreInteractions(mockServicePlanRemoteDataSource);
    });
  });
}
