import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/features/exchange/exchange_controller.dart';
import 'package:amar_pos/features/exchange/presentation/exchange_steps/exchange_product_selection_step.dart';
import 'package:amar_pos/features/exchange/presentation/exchange_steps/exchange_summary.dart';
import 'package:amar_pos/features/exchange/presentation/exchange_steps/return_product_selection_step.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExchangeView extends StatefulWidget {
  const ExchangeView({super.key});

  @override
  State<ExchangeView> createState() => _ExchangeViewState();
}

class _ExchangeViewState extends State<ExchangeView> {
  int _currentStep = 0;

  ExchangeController controller = Get.put(ExchangeController());

  ControlsDetails controlsDetails =
      ControlsDetails(currentStep: 0, stepIndex: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Theme(
        data: ThemeData(
          canvasColor: AppColors.lightGreen.withOpacity(.2),
          // primaryColor: AppColors.primary,
          dividerTheme: DividerThemeData(
            space: 0,
            thickness: 0,
          ),
          colorScheme: ColorScheme.light(
              primary: AppColors.primary, surface: Colors.white),
        ),
        child: GetBuilder<ExchangeController>(
          id: 'exchange_view',
          builder: (controller) {
            return Stepper(
              margin: EdgeInsets.zero,
              connectorThickness: 2,
              // stepIconMargin: EdgeInsets.only(bottom: 8),
              stepIconHeight: 32,
              elevation: 0,
              // connectorColor: WidgetStatePropertyAll(AppColors.primary),
              type: StepperType.horizontal,
              physics: controller.currentStep != 2
                  ? const NeverScrollableScrollPhysics()
                  : const ClampingScrollPhysics(),
              currentStep: controller.currentStep,
              onStepContinue: controller.currentStep == 2
                  ? controller.onSubmit
                  : controller.onStepContinue,
              onStepCancel: controller.onStepCancel,

              steps: [
                Step(
                    // title: SizedBox.shrink(),
                    content: ReturnProductSelectionStep(),
                    state: controller.currentStep > 0
                        ? StepState.complete
                        : StepState.indexed,
                    isActive: controller.currentStep == 0,
                    stepStyle: StepStyle(),
                    title: Text("Return",
                        style: controller.currentStep == 0
                            ? TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold)
                            : null)),
                Step(
                  title: Text("Exchange",
                      style: controller.currentStep == 1
                          ? TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold)
                          : null),
                  // title: SizedBox.shrink(),
                  content: ExchangeProductSelectionStep(),
                  state: controller.currentStep > 1
                      ? StepState.complete
                      : StepState.indexed,
                  isActive: controller.currentStep == 1,
                ),
                Step(
                  title: Text("Summary",
                      style: controller.currentStep == 2
                          ? const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold)
                          : null),
                  // title: SizedBox.shrink(),
                  content: Visibility(
                      visible: controller.currentStep == 2,
                      child: ExchangeSummary()),
                  state: StepState.indexed,
                  isActive: controller.currentStep == 2,
                ),
              ],
              controlsBuilder:
                  (BuildContext context, ControlsDetails details) {
                controlsDetails = details;
                return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
      bottomNavigationBar: _buildCustomButtons(controlsDetails),
    );
  }

  Widget _buildCustomButtons(ControlsDetails details) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GetBuilder<ExchangeController>(
        id: 'exchange_view_controller',
        builder: (controller) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (controller.currentStep > 0)
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          onTap: controller.onStepCancel,
                          text: 'Back',
                          color: Colors.grey,
                        ),
                      ),
                      addW(10),
                    ],
                  ),
                ),
              if (controller.currentStep < 2)
                Expanded(
                  child: CustomButton(
                    onTap: controller.onStepContinue,
                    text: 'Next',
                  ),
                ),
              if (controller.currentStep == 2)
                Expanded(
                  child: Row(
                    children: [
                      addW(10),
                      Expanded(
                        child: CustomButton(
                          onTap: controller.onSubmit,
                          text: controller.isEditing ? 'Update' : 'Submit',
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
