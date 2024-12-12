import 'dart:convert'; // Add Firestore import
import 'package:church_service_planner/features/service_planning/domain/entities/service_plan.dart';

// Data layer model class
class ServicePlanModel extends ServicePlan {
  const ServicePlanModel({
    required super.id,
    required super.date,
    required super.timeStart,
    required super.timeEnd,
    required super.location,
    required super.serviceType,
  });

  // Create a model from a Firestore map
  factory ServicePlanModel.fromMap(Map<String, dynamic> map, String id) {
    return ServicePlanModel(
      id: id, // Document ID is passed separately
      date: map['date'], // Convert Firestore string to DateTime
      timeStart: map['timeStart'],
      timeEnd: map['timeEnd'],
      location: map['location'],
      serviceType: map['serviceType'],
    );
  }

  // Method to create a model from a JSON string
  factory ServicePlanModel.fromJson(String source) {
    return ServicePlanModel.fromMap(
        Map<String, dynamic>.from(json.decode(source)), "");
  }

  // Convert the model to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date, // Convert DateTime to Firestore Timestamp
      'timeStart': timeStart,
      'timeEnd': timeEnd,
      'location': location,
      'serviceType': serviceType,
    };
  }

  // Convert the model to a JSON string
  String toJson() {
    return json.encode(toMap());
  }
}
