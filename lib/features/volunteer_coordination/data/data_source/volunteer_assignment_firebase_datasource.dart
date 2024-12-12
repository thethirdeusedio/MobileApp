import 'package:church_service_planner/core/errors/exceptions.dart';
import 'package:church_service_planner/features/volunteer_coordination/data/data_source/volunteer_assignment_remote_datasource.dart';
import 'package:church_service_planner/features/volunteer_coordination/data/models/volunteer_assignment_model.dart';
import 'package:church_service_planner/features/volunteer_coordination/domain/entities/volunteer_assignment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VolunteerAssignmentFirebaseDataSource
    implements VolunteerAssignmentRemoteDataSource {
  final FirebaseFirestore _firestore;

  VolunteerAssignmentFirebaseDataSource(this._firestore);

  @override
  Future<void> createVolunteerAssignment(VolunteerAssignment assignment) async {
    try {
      final volunteerAssignmentDocRef =
          _firestore.collection('volunteerAssignments').doc();
      final volunteerAssignmentModel = VolunteerAssignmentModel(
          id: volunteerAssignmentDocRef.id,
          role: assignment.role,
          volunteerName: assignment.volunteerName,
          date: assignment.date,
          serviceId: assignment.serviceId);
      await volunteerAssignmentDocRef.set(volunteerAssignmentModel.toMap());
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? "Uknown error has occured", statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<void> deleteVolunteerAssignment(VolunteerAssignment assignment) async {
    try {
      await _firestore
          .collection('volunteerAssignments')
          .doc(assignment.id)
          .delete();
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? "Uknown error has occured", statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<List<VolunteerAssignment>> readAllVolunteerAssignments() async {
    try {
      final querySnapshot = await _firestore
          .collection('volunteerAssignments')
          .orderBy('date', descending: false)
          .get();

      return querySnapshot.docs
          .map((doc) => VolunteerAssignment(
                id: doc.id,
                date: doc['date'],
                serviceId: doc['serviceId'] ?? '',
                volunteerName: doc['volunteerName'] ?? '',
                role: doc['role'] ?? '', // Fixed here // Fixed here
              ))
          .toList();
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? "Uknown error has occured", statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<VolunteerAssignment?> readVolunteerAssignmentById(
      VolunteerAssignment assignment) async {
    try {
      final doc = await _firestore
          .collection('volunteerAssignments')
          .doc(assignment.id)
          .get();
      if (doc.exists) {
        return VolunteerAssignment(
          id: doc.id,
          date: doc['date'],
          serviceId: doc['serviceId'] ?? '',
          volunteerName: doc['volunteerName'] ?? '',
          role: doc['role'] ?? '', // Fixed here // Fixed here
        );
      }
      return null;
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? "Uknown error has occured", statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<void> updateVolunteerAssignment(VolunteerAssignment assignment) async {
    final volunteerAssignmentModel = VolunteerAssignmentModel(
        id: assignment.id,
        role: assignment.role,
        volunteerName: assignment.volunteerName,
        date: assignment.date,
        serviceId: assignment.serviceId);
    try {
      await _firestore
          .collection('volunteerAssignments')
          .doc(assignment.id)
          .update(volunteerAssignmentModel.toMap());
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? "Uknown error has occured", statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }
}
