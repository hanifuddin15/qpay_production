import 'package:flutter/material.dart';
import 'package:qpay/res/resources.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class MyStepIndicator extends StatelessWidget {
  final totalSteps;
  final currentStep;

  const MyStepIndicator(this.totalSteps, this.currentStep);

  @override
  Widget build(BuildContext context) {
    return StepProgressIndicator(
        totalSteps: totalSteps,
        currentStep: currentStep,
        selectedColor: Colours.app_main,
        unselectedColor: Colours.bg_gray,
        padding: 0
    );
  }
}
