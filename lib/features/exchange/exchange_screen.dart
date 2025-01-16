import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/custom_text_field.dart';
import 'package:amar_pos/core/widgets/field_title.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/custom_dropdown_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../core/responsive/pixel_perfect.dart';

class ExchangeScreen extends StatefulWidget {
  const ExchangeScreen({super.key});

  @override
  State<ExchangeScreen> createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends State<ExchangeScreen> {
  int _currentStep = 0;

  void _onStepContinue() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _onSubmit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Submission"),
        content: Text("Form submitted successfully!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  ControlsDetails controlsDetails = ControlsDetails(currentStep: 0, stepIndex: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Stepper'),
      ),
      body: Column(
        children: [
          Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Stepper(
              elevation: 0,
              connectorColor: WidgetStatePropertyAll(AppColors.primary),
              type: StepperType.horizontal,
              currentStep: _currentStep,
              onStepContinue: _currentStep == 2 ? _onSubmit : _onStepContinue,
              onStepCancel: _onStepCancel,

              onStepTapped: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              steps: [
                Step(
                    title: SizedBox.shrink(),
                    content: _buildStepContent("Return Products Selection"),
                    state: _currentStep > 0
                        ? StepState.complete
                        : StepState.indexed,
                    isActive: _currentStep == 0,
                    stepStyle: StepStyle(

                    ),
                    label: Text("Return")
                ),
                Step(
                  label: Text("Exchange"),
                  title: SizedBox.shrink(),
                  content: _buildStepContent("Exchange Products Selection"),
                  state: _currentStep > 1
                      ? StepState.complete
                      : StepState.indexed,
                  isActive: _currentStep == 1,
                ),
                Step(
                  label: Text("Calculate"),
                  title: SizedBox.shrink(),
                  content: _buildStepContent("Calculation"),
                  state: StepState.indexed,
                  isActive: _currentStep == 2,
                ),
              ],
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                controlsDetails = details;
                return SizedBox.shrink();
              },
            ),
          ))
        ],
      ),
      bottomNavigationBar: _buildCustomButtons(controlsDetails),
    );
  }

  Widget _buildStepContent(String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildCustomButtons(ControlsDetails details) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep > 0)
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onTap: details.onStepCancel,
                      text: 'Back',
                      color: Colors.grey,
                    ),
                  ),
                  addW(10),
                ],
              ),
            ),

          if (_currentStep < 2)
            Expanded(
              child: CustomButton(
                onTap: details.onStepContinue,
                text: 'Next',
              ),
            ),
          if (_currentStep == 2)
            Expanded(
              child: Row(
                children: [
                  addW(10),
                  Expanded(
                    child: CustomButton(
                      onTap: _onSubmit,
                      text: 'Submit',
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}