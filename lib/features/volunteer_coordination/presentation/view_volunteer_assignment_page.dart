import 'package:church_service_planner/core/services/injection_container.dart';
import 'package:church_service_planner/features/service_planning/presentation/view_service_plan_row.dart';
import 'package:church_service_planner/features/volunteer_coordination/domain/entities/volunteer_assignment.dart';
import 'package:church_service_planner/features/volunteer_coordination/presentation/create_update_volunteer_assignment_page.dart';
import 'package:church_service_planner/features/volunteer_coordination/presentation/cubit/volunteer_coordination_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: ViewVolunteerAssignmentPage(
              volunteerAssignment: VolunteerAssignment(
        id: '123',
        role: 'Drummer',
        volunteerName: 'Martin Llorag',
        date: '2024-12-16',
        serviceId: 'esehuf',
      ))),
    ),
  );
}

class ViewVolunteerAssignmentPage extends StatefulWidget {
  final VolunteerAssignment volunteerAssignment;

  const ViewVolunteerAssignmentPage({
    super.key,
    required this.volunteerAssignment,
  });

  @override
  State<ViewVolunteerAssignmentPage> createState() =>
      _ViewVolunteerAssignmentPageState();
}

class _ViewVolunteerAssignmentPageState
    extends State<ViewVolunteerAssignmentPage> {
  late VolunteerAssignment _currentVolunteerAssignment;

  @override
  void initState() {
    super.initState();
    _currentVolunteerAssignment = widget.volunteerAssignment;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VolunteerAssignmentCubit, VolunteerCoordinationState>(
      listener: (context, state) {
        if (state is VolunteerAssignmentDeleted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Navigator.pop(context, "Volunteer Assignment deleted");
        } else if (state is VolunteerAssignmentError) {
          final snackBar = SnackBar(
            content: Text(state.message),
            duration: const Duration(seconds: 5),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Volunteer Assignment"),
          actions: [
            IconButton(
                onPressed: () async {
                  final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) =>
                              serviceLocator<VolunteerAssignmentCubit>(),
                          child: CreateUpdateVolunteerAssignmentPage(
                              volunteerAssignment: _currentVolunteerAssignment),
                        ),
                      ));

                  if (result.runtimeType == VolunteerAssignment) {
                    setState(() {
                      _currentVolunteerAssignment = result;
                    });
                  }
                },
                icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  const snackBar = SnackBar(
                    content: Text("Deleting Volunteer assignment..."),
                    duration: Duration(seconds: 9),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  context
                      .read<VolunteerAssignmentCubit>()
                      .deleteAssignment(widget.volunteerAssignment);
                },
                icon: const Icon(Icons.delete))
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            LabelValueRow(
              label: 'Name',
              value: _currentVolunteerAssignment.volunteerName,
            ),
            LabelValueRow(
              label: 'Service Type',
              value: _currentVolunteerAssignment.serviceId,
            ),
            LabelValueRow(
              label: 'Role',
              value: _currentVolunteerAssignment.role,
            ),
          ],
        ),
      ),
    );
  }
}
