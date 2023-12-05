import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; 
class Accounttrack extends StatelessWidget {
  const Accounttrack({
    Key? key,
    required this.text,
    required this.icon,
    required this.press,
  }) : super(key: key); 
  final String text, icon;
  final VoidCallback press;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.grey[200],
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: press,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 22,
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const Icon(
              Icons.arrow_right,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
//agentform