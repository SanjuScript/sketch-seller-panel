import 'package:another_stepper/dto/stepper_data.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:drawer_panel/HELPERS/date_formater.dart';
import 'package:drawer_panel/MODEL/HELPER/status_model.dart';
import 'package:drawer_panel/MODEL/ORDER/order_details.dart';
import 'package:flutter/material.dart';

class StepperWidget extends StatelessWidget {
  final OrderDetailModel orderDetailModel;
  final List<StatusModel> statuses;
  final int currentStep;
  const StepperWidget(
      {super.key,
      required this.orderDetailModel,
      required this.statuses,
      required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnotherStepper(
        stepperList: statuses.asMap().entries.map((entry) {
          final stepIndex = entry.key;
          final status = entry.value;

          DateTime? updatedTime =
              orderDetailModel.tracking?.updatedStages[status.title];

          return StepperData(
            title: StepperText(
              status.title,
              textStyle: TextStyle(
                color: Colors.black,
                fontWeight: stepIndex == currentStep
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            subtitle: StepperText(
              updatedTime != null
                  ? "${status.subtitle}\n${DateFormatHelper.formatDateTime(updatedTime)}"
                  : '',
              textStyle: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            iconWidget: CircleAvatar(
              backgroundColor: stepIndex < currentStep
                  ? Colors.deepPurple
                  : (stepIndex == currentStep ? status.color : Colors.grey),
              child: Icon(
                status.icon,
                color: Colors.white,
                size: 20,
              ),
            ),
          );
        }).toList(),
        activeIndex: currentStep,
        stepperDirection: Axis.vertical,
        verticalGap: 20,
        barThickness: 5,
        activeBarColor: Colors.deepPurple,
        inActiveBarColor: Colors.grey,
        iconHeight: 35,
        iconWidth: 35,
      ),
    );
  }
}
