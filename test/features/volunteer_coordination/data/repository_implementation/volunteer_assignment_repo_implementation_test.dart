import 'package:church_service_planner/core/errors/failure.dart';
import 'package:church_service_planner/features/volunteer_coordination/data/data_source/volunteer_assignment_remote_datasource.dart';
import 'package:church_service_planner/features/volunteer_coordination/data/repository_implementation/volunteer_assignment_repo_implementation.dart';
import 'package:church_service_planner/features/volunteer_coordination/domain/entities/volunteer_assignment.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart'; // For Either

// Mocking the external data source (Assuming there's a VolunteerAssignmentDataSource)
class MockVolunteerAssignmentRemoteDataSource extends Mock
    implements VolunteerAssignmentRemoteDataSource {}

Future<void> main() async {
  late VolunteerAssignmentRepositoryImplementation
      volunteerAssignmentRepositoryUnderTest;
  late MockVolunteerAssignmentRemoteDataSource
      mockVolunteerAssignmentRemoteDataSource;

  setUp(() {
    mockVolunteerAssignmentRemoteDataSource =
        MockVolunteerAssignmentRemoteDataSource();
    volunteerAssignmentRepositoryUnderTest =
        VolunteerAssignmentRepositoryImplementation(
            mockVolunteerAssignmentRemoteDataSource);
  });

  final testAssignment = VolunteerAssignment(
    id: '1',
    role: 'Usher',
    volunteerName: 'John Doe',
    date: '2024-12-16',
    serviceId: 'service_1',
  );

  group('CreateVolunteerAssignment', () {
    test('should return Right(void) on success', () async {
      // Arrange: Stub the data source to return success
      when(() => mockVolunteerAssignmentRemoteDataSource
              .createVolunteerAssignment(testAssignment))
          .thenAnswer((_) async => Future.value());

      // Act: Call the repository method
      final result = await volunteerAssignmentRepositoryUnderTest
          .createVolunteerAssignment(testAssignment);

      // Assert: Expect a Right(void)
      expect(result, const Right(null));
      verify(() => mockVolunteerAssignmentRemoteDataSource
          .createVolunteerAssignment(testAssignment)).called(1);
      verifyNoMoreInteractions(mockVolunteerAssignmentRemoteDataSource);
    });

    test('should return Left(Failure) when an exception is thrown', () async {
      // Arrange: Stub the data source to throw an exception
      when(() => mockVolunteerAssignmentRemoteDataSource
              .createVolunteerAssignment(testAssignment))
          .thenThrow(Exception('Database error'));

      // Act: Call the repository method
      final result = await volunteerAssignmentRepositoryUnderTest
          .createVolunteerAssignment(testAssignment);

      // Assert: Expect a Left(Failure)
      expect(result, isA<Left<Failure, void>>());
      verify(() => mockVolunteerAssignmentRemoteDataSource
          .createVolunteerAssignment(testAssignment)).called(1);
      verifyNoMoreInteractions(mockVolunteerAssignmentRemoteDataSource);
    });
  });

  group('deleteVolunteerAssignment', () {
    final testAssignment = VolunteerAssignment(
      id: '1',
      role: 'Usher',
      volunteerName: 'John Doe',
      date: '2024-12-16',
      serviceId: 'service_1',
    );
    test('should return success when delete is successful', () async {
      // Arrange
      when(() => mockVolunteerAssignmentRemoteDataSource
          .deleteVolunteerAssignment(testAssignment)).thenAnswer((_) async {});

      // Act
      final result = await volunteerAssignmentRepositoryUnderTest
          .deleteVolunteerAssignment(testAssignment);

      // Assert
      expect(result, const Right(null));
      verify(() => mockVolunteerAssignmentRemoteDataSource
          .deleteVolunteerAssignment(testAssignment)).called(1);
      verifyNoMoreInteractions(mockVolunteerAssignmentRemoteDataSource);
    });

    test('should return failure when delete fails', () async {
      // Arrange
      when(() => mockVolunteerAssignmentRemoteDataSource
          .deleteVolunteerAssignment(testAssignment)).thenThrow(Exception());

      // Act
      final result = await volunteerAssignmentRepositoryUnderTest
          .deleteVolunteerAssignment(testAssignment);

      // Assert
      expect(result, isA<Left<Failure, void>>());
      verify(() => mockVolunteerAssignmentRemoteDataSource
          .deleteVolunteerAssignment(testAssignment)).called(1);
      verifyNoMoreInteractions(mockVolunteerAssignmentRemoteDataSource);
    });
  });

  group('readAllVolunteerAssignments', () {
    test('should return a list of volunteer assignments when successful',
        () async {
      // Arrange
      final mockAssignments = [
        VolunteerAssignment(
            id: '1',
            role: 'Usher',
            volunteerName: 'John Doe',
            date: '2024-12-16',
            serviceId: 'service1'),
        VolunteerAssignment(
            id: '2',
            role: 'Greeter',
            volunteerName: 'Jane Doe',
            date: '2024-12-16',
            serviceId: 'service2'),
      ];
      when(() => mockVolunteerAssignmentRemoteDataSource
              .readAllVolunteerAssignments())
          .thenAnswer((_) async => mockAssignments);

      // Act
      final result = await volunteerAssignmentRepositoryUnderTest
          .readAllVolunteerAssignments();

      // Assert
      expect(result, Right(mockAssignments));
    });

    test('should return a Failure when an exception is thrown', () async {
      // Arrange
      when(() => mockVolunteerAssignmentRemoteDataSource
              .readAllVolunteerAssignments())
          .thenThrow(Exception('Something went wrong'));

      // Act
      final result = await volunteerAssignmentRepositoryUnderTest
          .readAllVolunteerAssignments();

      // Assert
      expect(result, isA<Left<Failure, List<VolunteerAssignment>>>());
      expect(result.isLeft(), true);
    });
  });

  group('readAllVolunteerAssignmentsById', () {
    final testAssignment = VolunteerAssignment(
      id: '1',
      role: 'Usher',
      volunteerName: 'John Doe',
      date: '2024-12-16',
      serviceId: 'service_1',
    );
    test(
        'should return a VolunteerAssignment when readVolunteerAssignmentById succeeds',
        () async {
      // Arrange

      when(() => mockVolunteerAssignmentRemoteDataSource
              .readVolunteerAssignmentById(testAssignment))
          .thenAnswer((_) async => testAssignment);

      // Act
      final result = await volunteerAssignmentRepositoryUnderTest
          .readVolunteerAssignmentById(testAssignment);

      // Assert
      expect(result, Right(testAssignment));
    });

    test('should return a Failure when readVolunteerAssignmentById fails',
        () async {
      // Arrange
      when(() => mockVolunteerAssignmentRemoteDataSource
              .readVolunteerAssignmentById(testAssignment))
          .thenThrow(Exception('Error fetching volunteer assignment'));

      // Act
      final result = await volunteerAssignmentRepositoryUnderTest
          .readVolunteerAssignmentById(testAssignment);

      // Assert
      expect(result, isA<Left<Failure, VolunteerAssignment?>>());
    });
  });

  group('updateVolunteerAssignment', () {
    final volunteerAssignment = VolunteerAssignment(
      id: '1',
      role: 'Role',
      volunteerName: 'Name',
      date: '2024-12-16',
      serviceId: 'service1',
    );

    test('should return void on successful update', () async {
      // Arrange
      // Here you might need to set up any necessary stubs or mocks
      when(() => mockVolunteerAssignmentRemoteDataSource
              .updateVolunteerAssignment(volunteerAssignment))
          .thenAnswer((_) async => volunteerAssignment);

      // Act
      final result = await volunteerAssignmentRepositoryUnderTest
          .updateVolunteerAssignment(volunteerAssignment);

      // Assert
      expect(result, Right(volunteerAssignment));
    });

    test('should return Failure on unsuccessful update', () async {
      // Arrange
      when(() => mockVolunteerAssignmentRemoteDataSource
              .updateVolunteerAssignment(volunteerAssignment))
          .thenThrow(Exception('Update failed'));

      // Act
      final result = await volunteerAssignmentRepositoryUnderTest
          .updateVolunteerAssignment(volunteerAssignment);

      // Assert
      expect(result, isA<Left<Failure, void>>());
    });
  });
}
