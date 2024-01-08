import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_credential/controller/login_controller.dart';
import 'package:finkin_credential/pages/agent_verification/verification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home_screen/bottom_nav.dart';
// Import your VerifyAgent widget

class CheckLogin extends StatefulWidget {
  const CheckLogin({Key? key}) : super(key: key);

  @override
  _CheckLoginState createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  final LoginController loginController = Get.put(LoginController());
  @override
  void initState() {
    super.initState();
    String id = loginController.agentId.value;
    // Check isAccepted status in Firestore

    checkIsAcceptedStatus(id);
  }

  Future<void> checkIsAcceptedStatus(String loggedInAgentId) async {
    try {
      // Retrieve the agent document from Firestore where agentId matches the logged-in agent's ID
      QuerySnapshot agentDocs = await FirebaseFirestore.instance
          .collection('Agents')
          .where('AgentId', isEqualTo: loggedInAgentId)
          .get();

      // Check if there is exactly one document that matches the query
      if (agentDocs.docs.length == 1) {
        DocumentSnapshot agentDoc = agentDocs.docs[0];
        bool isAccepted = agentDoc['IsAccepted'] ?? false;

        if (isAccepted) {
          // If isAccepted is true, navigate to BottomNavBar
          Get.off(() => const BottomNavBar());
        } else {
          // If isAccepted is false, navigate to VerifyAgent
          Get.off(() => const VerifyAgent());
        }
      } else if (agentDocs.docs.isEmpty) {
        // Handle the case when the agent document doesn't exist
        print('Agent document not found for ID: $loggedInAgentId');
        // You may want to display an error message or handle it accordingly
      } else {
        // Handle the case when there are multiple documents with the same agentId
        print('Multiple agent documents found for ID: $loggedInAgentId');
        // You may want to display an error message or handle it accordingly
      }
    } catch (e) {
      // Handle any potential errors during the Firestore operation
      print('Error checking isAccepted status: $e');
      // You may want to display an error message or handle it accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    // You can display a loading animation here if needed
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
