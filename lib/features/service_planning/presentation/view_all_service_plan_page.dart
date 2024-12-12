import 'package:church_service_planner/core/services/injection_container.dart';
import 'package:church_service_planner/core/widgets/empty_state_list.dart';
import 'package:church_service_planner/core/widgets/error_state_list.dart';
import 'package:church_service_planner/core/widgets/loading_state_shimmer_list.dart';
import 'package:church_service_planner/features/service_planning/presentation/create_update_service_plan_page.dart';
import 'package:church_service_planner/features/service_planning/presentation/cubit/service_planning_cubit.dart';
import 'package:church_service_planner/features/service_planning/presentation/view_service_plan_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewAllServicePlanPage extends StatefulWidget {
  const ViewAllServicePlanPage({super.key});

  @override
  State<ViewAllServicePlanPage> createState() => _ViewAllServicePlanPageState();
}

class _ViewAllServicePlanPageState extends State<ViewAllServicePlanPage> {
  @override
  void initState() {
    super.initState();
    context.read<ServicePlanCubit>().readAllServicePlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Church Service Plans'),
      ),
      body: BlocBuilder<ServicePlanCubit, ServicePlanningState>(
        builder: (context, state) {
          if (state is ServicePlanningLoading) {
            return const LoadingStateShimmerList();
          } else if (state is ServicePlanningLoaded) {
            if (state.servicePlans.isEmpty) {
              return const EmptyStateList(
                imageAssetName: 'assets/images/empty.png',
                title: 'Oops...There are no Service Plans here',
                description: "Tap '+' button to create a new Service Plan",
              );
            }

            return ListView.builder(
              itemCount: state.servicePlans.length,
              itemBuilder: (context, index) {
                final currentServicePlan = state.servicePlans[index];

                return Card(
                  child: ListTile(
                    title:
                        Text("Service Type: ${currentServicePlan.serviceType}"),
                    onTap: () async {
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) =>
                                  serviceLocator<ServicePlanCubit>(),
                              child: ViewServicePlanPage(
                                  servicePlan: currentServicePlan),
                            ),
                          ));
                      context.read<ServicePlanCubit>().readAllServicePlans();

                      if (result.runtimeType == String) {
                        final snackBar = SnackBar(content: Text(result));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                  ),
                );
              },
            );
          } else if (state is ServicePlanningError) {
            return EmptyStateList(
              imageAssetName: 'assets/images/empty.png',
              title: 'Opps...There are no service plans here',
              description: "tap '+' button to create a new service plan",
            );
          } else {
            return ErrorStateList(
              imageAssetName: 'assets/images/error.png',
              errorMessage: state.message,
              onRetry: () {
                context.read<ServicePlanCubit>().readAllServicePlans();
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
                  create: (context) => serviceLocator<ServicePlanCubit>(),
                  child: const CreateUpdateServicePlanPage(),
                ),
              ));

          context
              .read<ServicePlanCubit>()
              .readAllServicePlans(); //refresh the read all service Plan page

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
