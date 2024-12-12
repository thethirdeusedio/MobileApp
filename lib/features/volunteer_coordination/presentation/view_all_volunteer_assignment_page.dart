import 'package:church_service_planner/core/services/injection_container.dart';
import 'package:church_service_planner/core/widgets/empty_state_list.dart';
import 'package:church_service_planner/core/widgets/error_state_list.dart';
import 'package:church_service_planner/core/widgets/loading_state_shimmer_list.dart';
import 'package:church_service_planner/features/volunteer_coordination/presentation/create_update_volunteer_assignment_page.dart';
import 'package:church_service_planner/features/volunteer_coordination/presentation/cubit/volunteer_coordination_cubit.dart';
import 'package:church_service_planner/features/volunteer_coordination/presentation/view_volunteer_assignment_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewAllVolunteerAssignmentPage extends StatefulWidget {
  const ViewAllVolunteerAssignmentPage({super.key});

  @override
  State<ViewAllVolunteerAssignmentPage> createState() =>
      _ViewAllVolunteerAssignmentPageState();
}

class _ViewAllVolunteerAssignmentPageState
    extends State<ViewAllVolunteerAssignmentPage> {
  @override
  void initState() {
    super.initState();
    context.read<VolunteerAssignmentCubit>().readAllVolunteerAssignment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Assignment'),
      ),
      body: BlocBuilder<VolunteerAssignmentCubit, VolunteerCoordinationState>(
        builder: (context, state) {
          if (state is VolunteerAssignmentLoading) {
            return const LoadingStateShimmerList();
          } else if (state is VolunteerAssignmentLoaded) {
            if (state.assignment.isEmpty) {
              return const EmptyStateList(
                imageAssetName: 'assets/images/empty.png',
                title: 'Oops...There are no Volunteer assignment here',
                description:
                    "Tap '+' button to create a new Volunteer Assignment",
              );
            }

            return ListView.builder(
              itemCount: state.assignment.length,
              itemBuilder: (context, index) {
                final currentVolunteerAssignment = state.assignment[index];

                return Card(
                  child: ListTile(
                    title: Text(
                        "Volunteer Name: ${currentVolunteerAssignment.volunteerName}"),
                    onTap: () async {
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) =>
                                  serviceLocator<VolunteerAssignmentCubit>(),
                              child: ViewVolunteerAssignmentPage(
                                  volunteerAssignment:
                                      currentVolunteerAssignment),
                            ),
                          ));
                      context
                          .read<VolunteerAssignmentCubit>()
                          .readAllVolunteerAssignment();

                      if (result.runtimeType == String) {
                        final snackBar = SnackBar(content: Text(result));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                  ),
                );
              },
            );
          } else if (state is VolunteerAssignmentError) {
            return EmptyStateList(
              imageAssetName: 'assets/images/empty.png',
              title: 'Opps...There are no volunteer assignments here',
              description:
                  "tap '+' button to create a new volunteer assignment",
            );
          } else {
            return ErrorStateList(
              imageAssetName: 'assets/images/error.png',
              errorMessage: state.message,
              onRetry: () {
                context
                    .read<VolunteerAssignmentCubit>()
                    .readAllVolunteerAssignment();
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) =>
                      serviceLocator<VolunteerAssignmentCubit>(),
                  child: const CreateUpdateVolunteerAssignmentPage(),
                ),
              ));

          context
              .read<VolunteerAssignmentCubit>()
              .readAllVolunteerAssignment(); //refresh the read all service Plan page

          if (result.runtimeType == String) {
            final snackBar = SnackBar(content: Text(result));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
