import 'package:finkin_credential/controller/agent_form_controller.dart';
import 'package:finkin_credential/pages/agent_screen/agent_form.dart';
import 'package:finkin_credential/res/app_color/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomRadio extends StatelessWidget {
  final String value;
  final String? groupValue;
  final ValueChanged<String?> onChanged;
  final Color activeColor;
  final Color backgroundColor;
  final double textFontSize;

  CustomRadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.activeColor,
    this.backgroundColor = Colors.transparent,
    this.textFontSize = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(value);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Container(
              width: 18.0,
              height: 18.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    groupValue == value ? backgroundColor : AppColor.textLight,
              ),
              child: Center(
                child: Container(
                  width: 14.0,
                  height: 14.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        groupValue == value ? activeColor : AppColor.textLight,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15.0),
            Center(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 22.0,
                  color: AppColor.textLight,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AgentPage extends StatefulWidget {
  const AgentPage({Key? key}) : super(key: key);

  @override
  _AgentPageState createState() => _AgentPageState();
}

class _AgentPageState extends State<AgentPage> {
  String? selectedAgentType;
  Color buttonColor = AppColor.secondary;
  String? errorMessage;
  final AgentFormController agentFormController =
      Get.put(AgentFormController());

  void _handleCustomRadioChange(String? value) {
    setState(() {
      selectedAgentType = value;
      errorMessage = null;
      agentFormController.setSelectedAgentType(value!);
    });
  }

  void _handleContinueButtonClick() {
    if (selectedAgentType != null) {
      setState(() {
        buttonColor = AppColor.icon;
      });
      try {
        // Retrieve the currently authenticated user
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          String agentId = user.uid; // Use the UID as the agentId

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AgentForm(
                agentId: agentId,
              ),
            ),
          );
        } else {
          // Handle the case where the user is not authenticated
          // (You might want to redirect to the login screen or handle it differently)
          setState(() {
            errorMessage = "User not authenticated!";
          });
        }
      } catch (e) {
        // Handle any potential errors
        setState(() {
          errorMessage = "Error: $e";
        });
      }
    } else {
      setState(() {
        errorMessage = "Select your category!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Choose Type Of Agent",
              style: TextStyle(
                fontSize: 28.0,
                color: AppColor.textLight,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48.0),
            CustomRadio(
              value: 'FreeLancer',
              groupValue: selectedAgentType,
              onChanged: _handleCustomRadioChange,
              activeColor: AppColor.icon,
              textFontSize: 20.0,
            ),
            CustomRadio(
              value: 'Agent',
              groupValue: selectedAgentType,
              onChanged: _handleCustomRadioChange,
              activeColor: AppColor.icon,
            ),
            CustomRadio(
              value: 'DSR Agent',
              groupValue: selectedAgentType,
              onChanged: _handleCustomRadioChange,
              activeColor: AppColor.icon,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _handleContinueButtonClick,
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontSize: 18.0,
                  color: AppColor.textLight,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  buttonColor,
                ),
              ),
            ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: AppColor.textLight,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
