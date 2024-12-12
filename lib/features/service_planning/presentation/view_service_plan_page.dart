import 'package:church_service_planner/core/services/injection_container.dart';
import 'package:church_service_planner/features/service_planning/domain/entities/service_plan.dart';
import 'package:church_service_planner/features/service_planning/presentation/create_update_service_plan_page.dart';
import 'package:church_service_planner/features/service_planning/presentation/cubit/service_planning_cubit.dart';
import 'package:church_service_planner/features/service_planning/presentation/view_service_plan_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// void main() {
//   runApp(
//     MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: ViewServicePlanPage(
//           servicePlan: ServicePlan(
//             id: '123',
//             date: 'November 23, 2024',
//             timeStart: '10:00 AM',
//             timeEnd: '11:30 AM',
//             location: 'Brgy. Agas, Calubian, Leyte',
//             serviceType: 'Sunday Service',
//           ),
//         ),
//       ),
//     ),
//   );
// }

class ViewServicePlanPage extends StatefulWidget {
  final ServicePlan servicePlan;

  const ViewServicePlanPage({
    super.key,
    required this.servicePlan,
  });

  @override
  State<ViewServicePlanPage> createState() => _ViewServicePlanPageState();
}

class _ViewServicePlanPageState extends State<ViewServicePlanPage> {
  late ServicePlan _currentServicePlan;

  @override
  void initState() {
    super.initState();
    _currentServicePlan = widget.servicePlan;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServicePlanCubit, ServicePlanningState>(
      listener: (context, state) {
        if (state is ServicePlanDeleted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Navigator.pop(context, "Service Plan deleted");
        } else if (state is ServicePlanningError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_currentServicePlan.serviceType),
          actions: [
            IconButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => serviceLocator<ServicePlanCubit>(),
                      child: CreateUpdateServicePlanPage(
                        servicePlan: _currentServicePlan,
                      ),
                    ),
                  ),
                );

                if (result != null && result is ServicePlan) {
                  setState(() {
                    _currentServicePlan = result;
                  });
                }
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Deleting service plan..."),
                    duration: Duration(seconds: 2),
                  ),
                );
                context
                    .read<ServicePlanCubit>()
                    .deleteServicePlan(widget.servicePlan);
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            LabelValueRow(
              label: 'Location',
              value: _currentServicePlan.location,
            ),
            LabelValueRow(
              label: 'Date',
              value: _currentServicePlan.date,
            ),
            LabelValueRow(
              label: 'Time Start',
              value: _currentServicePlan.timeStart,
            ),
            LabelValueRow(
              label: 'Time End',
              value: _currentServicePlan.timeEnd,
            ),
          ],
        ),
      ),
    );
  }
}
