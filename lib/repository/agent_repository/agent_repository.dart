import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/agent_model/agent_model.dart';

class AgentRepository extends GetxController {
  static AgentRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createAgent(AgentModel agent) async {
    await _db
        .collection("Agents")
        .add(agent.toJson())
        .whenComplete(
          () => Get.snackbar("Success", "your form has been recorded",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.withOpacity(0.1),
              colorText: Colors.green),
        )
        .catchError((error, stackTrace) {
      Get.snackbar("Error", "Something went wrong. Try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green);
    });
  }

  Future<AgentModel> getAgentDetails(String phone) async {
    final snapshot =
        await _db.collection("Agents").where("Phone", isEqualTo: phone).get();
    final agentData =
        snapshot.docs.map((e) => AgentModel.fromSnapshot(e)).single;
    return agentData;
  }

  Future<List<AgentModel>> allAgent() async {
    final snapshot = await _db.collection("Agents").get();
    final agentData =
        snapshot.docs.map((e) => AgentModel.fromSnapshot(e)).toList();
    return agentData;
  }

  Future<bool> isAgentFormFilled(String agentId) async {
    try {
      CollectionReference agentCollection =
          FirebaseFirestore.instance.collection('Agents');
      QuerySnapshot querySnapshot =
          await agentCollection.where('AgentId', isEqualTo: agentId).get();
      print("agent id is");
      print(agentId);
      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data();
        bool isFormFilled =
            (data as Map<String, dynamic>)['isFormFilled'] ?? true;
        print("sadiya true or false");
        print(isFormFilled);
        return isFormFilled;
      } else {
        return false;
      }
    } catch (e) {
      print('Error checking Firestore: $e');
      return false;
    }
  }

  Future<AgentModel?> getAgentById(String agentId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('Agents')
          .where('AgentId', isEqualTo: agentId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> document =
            querySnapshot.docs.first;
        return AgentModel.fromSnapshot(document);
      } else {
        print("Document does not exist.");
        return null;
      }
    } catch (e) {
      print('Error fetching agent data: $e');
      return null;
    }
  }
}
