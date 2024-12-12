import 'package:church_service_planner/features/volunteer_coordination/domain/entities/volunteer_assignment.dart';
import 'package:church_service_planner/features/volunteer_coordination/presentation/cubit/volunteer_coordination_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CreateUpdateVolunteerAssignmentPage extends StatefulWidget {
  final VolunteerAssignment? volunteerAssignment;

  const CreateUpdateVolunteerAssignmentPage({
    super.key,
    this.volunteerAssignment,
  });

  @override
  State<CreateUpdateVolunteerAssignmentPage> createState() =>
      _CreateUpdateVolunteerAssignmentPageState();
}

class _CreateUpdateVolunteerAssignmentPageState
    extends State<CreateUpdateVolunteerAssignmentPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isPerforming = false;
  List<DropdownMenuItem<String>> _servicePlanItems = [];

  @override
  void initState() {
    super.initState();
    _fetchServicePlans();
  }

  Future<void> _fetchServicePlans() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('servicePlans').get();

      setState(() {
        _servicePlanItems = snapshot.docs.map((doc) {
          return DropdownMenuItem<String>(
            value: doc.id,
            child: Text(doc['serviceType']),
          );
        }).toList();
      });
    } catch (e) {
      _showErrorSnackbar("Error fetching service plans: $e");
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 5)),
    );
  }

  void _handleSubmit() {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) return;

    setState(() {
      _isPerforming = true;
    });

    final inputs = _formKey.currentState!.instantValue;
    final newVolunteerAssignment = VolunteerAssignment(
      id: widget.volunteerAssignment?.id ?? "",
      serviceId: inputs['serviceId'],
      volunteerName: inputs['volunteerName'],
      role: inputs['role'],
      date: inputs['date'],
    );

    if (widget.volunteerAssignment == null) {
      context
          .read<VolunteerAssignmentCubit>()
          .createAssignment(newVolunteerAssignment);
    } else {
      context
          .read<VolunteerAssignmentCubit>()
          .updateAssignment(newVolunteerAssignment);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBarTitle = widget.volunteerAssignment == null
        ? 'Create New Volunteer Assignment'
        : 'Update Volunteer Assignment';
    final buttonLabel = widget.volunteerAssignment == null
        ? 'Create Volunteer Assignment'
        : 'Update Volunteer Assignment';

    final initialValues = {
      'volunteerName': widget.volunteerAssignment?.volunteerName,
      'serviceId': widget.volunteerAssignment?.serviceId,
      'role': widget.volunteerAssignment?.role,
      'date': widget.volunteerAssignment?.date,
    };

    return BlocListener<VolunteerAssignmentCubit, VolunteerCoordinationState>(
      listener: (context, state) {
        if (state is VolunteerAssignmentCreated) {
          Navigator.pop(context, "Volunteer Assignment Created");
        } else if (state is VolunteerAssignmentError) {
          _showErrorSnackbar(state.message);
          setState(() {
            _isPerforming = false;
          });
        } else if (state is VolunteerAssignmentUpdated) {
          Navigator.pop(context, state.newVolunteerAssignment);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
        ),
        body: Column(
          children: [
            Expanded(
              child: FormBuilder(
                key: _formKey,
                initialValue: initialValues,
                child: ListView(
                  padding: const EdgeInsets.all(8.0),
                  children: [
                    FormBuilderTextField(
                      name: 'volunteerName',
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Volunteer Name',
                          hintText: 'Complete Name'),
                      validator: FormBuilderValidators.required(),
                    ),
                    const SizedBox(height: 16),
                    FormBuilderDropdown<String>(
                      name: 'serviceId',
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Select Service Type',
                      ),
                      items: _servicePlanItems,
                      validator: FormBuilderValidators.required(),
                    ),
                    const SizedBox(height: 16),
                    FormBuilderTextField(
                      name: 'role',
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Role',
                      ),
                      validator: FormBuilderValidators.required(),
                    ),
                    const SizedBox(height: 16),
                    FormBuilderTextField(
                      name: 'date',
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Date Now',
                        hintText: 'yy - mm- dd', // Add placeholder text here
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.date(),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isPerforming ? null : _handleSubmit,
                      child: _isPerforming
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(),
                            )
                          : Text(buttonLabel),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
