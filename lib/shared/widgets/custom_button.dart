import 'package:finkin_credential/res/app_color/app_color.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(AppColor.textLight),
          backgroundColor: MaterialStateProperty.all<Color>(AppColor.primary),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ))),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
//agentform