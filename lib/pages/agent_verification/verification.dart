import 'package:finkin_credential/pages/verification_screen/verification_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';

class VerifyAgent extends StatefulWidget {
  const VerifyAgent({super.key});

  @override
  VerifyAgentState createState() => VerifyAgentState();
}

class VerifyAgentState extends State<VerifyAgent> {
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    // Simulating the verification process
    // You can replace this with your actual verification logic
    // For demonstration, it waits for 5 seconds and then logs out
    Future.delayed(const Duration(seconds: 5), () {
      // Log out and navigate to a certain page
      _logoutAndNavigate();
    });
  }

  Future<void> _logoutAndNavigate() async {
    try {
      await _auth.signOut();
      print("User signed out");
      Get.offAll(VerificationScreen());
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Agent'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You are not verified',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            CountdownTimer(
              endTime: DateTime.now().millisecondsSinceEpoch + 5000,
              textStyle: const TextStyle(fontSize: 30, color: Colors.red),
              onEnd: () {
                // Callback when the countdown ends
                _logoutAndNavigate();
              },
            ),
          ],
        ),
      ),
    );
  }
}
