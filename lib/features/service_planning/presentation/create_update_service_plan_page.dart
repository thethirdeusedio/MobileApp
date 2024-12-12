import 'package:church_service_planner/features/service_planning/domain/entities/service_plan.dart';
import 'package:church_service_planner/features/service_planning/presentation/cubit/service_planning_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CreateUpdateServicePlanPage extends StatefulWidget {
  final ServicePlan? servicePlan;

  const CreateUpdateServicePlanPage({
    super.key,
    this.servicePlan,
  });

  @override
  State<CreateUpdateServicePlanPage> createState() =>
      _CreateUpdateServicePlanPageState();
}

class _CreateUpdateServicePlanPageState
    extends State<CreateUpdateServicePlanPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isPerforming = false;

  @override
  Widget build(BuildContext context) {
    String appBarTitle = widget.servicePlan == null
        ? 'Create New Service Plan'
        : 'Update Service Plan';
    String buttonLabel = widget.servicePlan == null
        ? 'Create Service Plan'
        : 'Update Service Plan';
    final initialValues = {
      'serviceType': widget.servicePlan?.serviceType,
      'location': widget.servicePlan?.location,
      'date': widget.servicePlan?.date,
      'timeStart': widget.servicePlan?.timeStart,
      'timeEnd': widget.servicePlan?.timeEnd,
    };

    return BlocListener<ServicePlanCubit, ServicePlanningState>(
      listener: (context, state) {
        if (state is ServicePlanCreated) {
          Navigator.pop(context, "Service Plan Created");
        } else if (state is ServicePlanningError) {
          final snackBar = SnackBar(
            content: Text(state.message),
            duration: const Duration(seconds: 5),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {
            _isPerforming = false;
          });
        } else if (state is ServicePlanUpdated) {
          Navigator.pop(context, state.newServicePlan);
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
              child: ListView(padding: EdgeInsets.all(8.0), children: [
                FormBuilderTextField(
                  name: 'serviceType',
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Church Service Plan'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                const SizedBox(
                  height: 16,
                ),
                FormBuilderTextField(
                  name: 'location',
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Location'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                const SizedBox(
                  height: 16,
                ),
                FormBuilderTextField(
                  name: 'date',
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Date',
                    hintText: 'yy - mm- dd', // Add placeholder text here
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.dateFuture(),
                    FormBuilderValidators.date(),
                  ]),
                ),
                const SizedBox(
                  height: 16,
                ),
                FormBuilderTextField(
                  name: 'timeStart',
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Time Start',
                      hintText: '00:00 AM/PM'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.time(),
                  ]),
                ),
                const SizedBox(
                  height: 16,
                ),
                FormBuilderTextField(
                  name: 'timeEnd',
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Time End',
                    hintText: '00:00 AM/PM',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.time(),
                  ]),
                ),
              ]),
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isPerforming
                          ? null
                          : () {
                              bool isValid = _formKey.currentState!.validate();
                              final inputs =
                                  _formKey.currentState!.instantValue;

                              if (isValid) {
                                setState(() {
                                  _isPerforming = true;
                                });

                                final newServicePlan = ServicePlan(
                                  id: widget.servicePlan?.id ?? "",
                                  date: inputs["date"],
                                  timeStart: inputs["timeStart"],
                                  timeEnd: inputs["timeEnd"],
                                  location: inputs["location"],
                                  serviceType: inputs["serviceType"],
                                );

                                if (widget.servicePlan == null) {
                                  context
                                      .read<ServicePlanCubit>()
                                      .createServicePlan(newServicePlan);
                                } else {
                                  context
                                      .read<ServicePlanCubit>()
                                      .updateExistingServicePlan(
                                          newServicePlan);
                                }
                              }
                            },
                      child: _isPerforming
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(),
                            )
                          : Text(buttonLabel),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
