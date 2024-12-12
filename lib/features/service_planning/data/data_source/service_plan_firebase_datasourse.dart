import 'package:church_service_planner/core/errors/exceptions.dart';
import 'package:church_service_planner/features/service_planning/data/data_source/service_plan_remote_data_source.dart';
import 'package:church_service_planner/features/service_planning/data/models/service_plan_model.dart';
import 'package:church_service_planner/features/service_planning/domain/entities/service_plan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServicePlanFirebaseDataSource implements ServicePlanRemoteDataSource {
  final FirebaseFirestore _firestore;

  const ServicePlanFirebaseDataSource(this._firestore);

  @override
  Future<void> createServicePlan(ServicePlan servicePlan) async {
    try {
      final servicePlanDocRef = _firestore.collection('servicePlans').doc();
      final servicePlanModel = ServicePlanModel(
        id: servicePlanDocRef.id,
        date: servicePlan.date,
        timeStart: servicePlan.timeStart,
        timeEnd: servicePlan.timeEnd,
        location: servicePlan.location,
        serviceType: servicePlan.serviceType,
      );
      await servicePlanDocRef.set(servicePlanModel.toMap());
    } on FirebaseException catch (e) {
      throw APIException(
        message: e.message ?? "Unknown error has occurred",
        statusCode: e.code,
      );
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<void> deleteServicePlan(ServicePlan servicePlan) async {
    try {
      await _firestore.collection('servicePlans').doc(servicePlan.id).delete();
    } on FirebaseException catch (e) {
      throw APIException(
        message: e.message ?? "Unknown error has occurred",
        statusCode: e.code,
      );
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<List<ServicePlan>> readAllServicePlans() async {
    try {
      final querySnapshot = await _firestore
          .collection('servicePlans')
          .orderBy('date', descending: false)
          .get();
      return querySnapshot.docs
          .map((doc) => ServicePlan(
                id: doc.id,
                date: doc['date'] ?? '',
                timeStart: doc['timeStart'] ?? '',
                timeEnd: doc['timeEnd'] ?? '',
                location: doc['location'] ?? '', // Fixed here
                serviceType: doc['serviceType'] ?? '', // Fixed here
              ))
          .toList();
    } on FirebaseException catch (e) {
      throw APIException(
        message: e.message ?? "Unknown error has occurred",
        statusCode: e.code,
      );
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<ServicePlan?> readServicePlanById(ServicePlan servicePlan) async {
    try {
      final doc =
          await _firestore.collection('servicePlans').doc(servicePlan.id).get();
      if (doc.exists) {
        return ServicePlan(
          id: doc.id,
          date: doc['date'] ?? '',
          timeStart: doc['timeStart'] ?? '',
          timeEnd: doc['time'] ?? '',
          location: doc['location'] ?? '',
          serviceType: doc['serviceType'] ?? '',
        );
      }
      return null;
    } on FirebaseException catch (e) {
      throw APIException(
        message: e.message ?? "Unknown error has occurred",
        statusCode: e.code,
      );
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<void> updateServicePlan(ServicePlan servicePlan) async {
    final servicePlanModel = ServicePlanModel(
      id: servicePlan.id,
      date: servicePlan.date,
      timeStart: servicePlan.timeStart,
      timeEnd: servicePlan.timeStart,
      location: servicePlan.location,
      serviceType: servicePlan.serviceType,
    );
    try {
      await _firestore
          .collection('servicePlans')
          .doc(servicePlan.id)
          .update(servicePlanModel.toMap());
    } on FirebaseException catch (e) {
      throw APIException(
        message: e.message ?? "Unknown error has occurred",
        statusCode: e.code,
      );
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }
}
