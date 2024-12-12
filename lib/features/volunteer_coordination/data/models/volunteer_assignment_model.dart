import 'dart:convert';

import 'package:church_service_planner/features/volunteer_coordination/domain/entities/volunteer_assignment.dart';

// Data layer model class
class VolunteerAssignmentModel extends VolunteerAssignment {
  const VolunteerAssignmentModel({
    required super.id,
    required super.role,
    required super.volunteerName,
    required super.date,
    required super.serviceId,
  });

  // Method to create a model from a map
  factory VolunteerAssignmentModel.fromMap(Map<String, dynamic> map) {
    return VolunteerAssignmentModel(
      id: map['id'],
      role: map['role'],
      volunteerName: map['volunteerName'],
      date: map['date'],
      serviceId: map['serviceId'],
    );
  }

  // Method to create a model from a JSON string
  factory VolunteerAssignmentModel.fromJson(String source) {
    return VolunteerAssignmentModel.fromMap(
        Map<String, dynamic>.from(json.decode(source)));
  }

  // Method to convert the model to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'role': role,
      'volunteerName': volunteerName,
      'date': date,
      'serviceId': serviceId,
    };
  }

  // Method to convert the model to a JSON string
  String toJson() {
    return json.encode(toMap());
  }
}
