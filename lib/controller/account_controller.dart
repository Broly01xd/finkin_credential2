import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  final fullName = ''.obs;
  final location = ''.obs;
  final email = ''.obs;
  final aadharCardNumber = ''.obs;
  final panCardNumber = ''.obs;

  Future<void> fetchAgentDetails(String agentId) async {
    try {
      print("Fetching user details for agentId: $agentId");

      final querySnapshot = await FirebaseFirestore.instance
          .collection('Agents')
          .where('AgentId', isEqualTo: agentId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first.data();
        print("User details fetched successfully: $userDoc");

        fullName.value = userDoc['Name'] ?? '';
        location.value = userDoc['Address'] ?? '';
        email.value = userDoc['Email'] ?? '';
        aadharCardNumber.value = userDoc['Aadhar'] ?? '';
        panCardNumber.value = userDoc['Pan'] ?? '';
      } else {
        print("User with agentId $agentId not found");
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }

  Future<void> fetchUserDetails(String userId) async {
    try {
      print("Fetching user details for userId: $userId");

      final querySnapshot = await FirebaseFirestore.instance
          .collection('Loan')
          .where('UserId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first.data();
        print("User details fetched successfully: $userDoc");

        fullName.value = userDoc['UserName'] ?? '';
        location.value = userDoc['Address'] ?? '';
        email.value = userDoc['Email'] ?? '';
        aadharCardNumber.value = userDoc['AadharNo'] ?? '';
        panCardNumber.value = userDoc['Pan'] ?? '';
      } else {
        print("User with agentId $userId not found");
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }
}
