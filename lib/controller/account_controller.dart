import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  final fullName = ''.obs;
  final location = ''.obs;
  final email = ''.obs;
  final aadharCardNumber = ''.obs;
  final panCardNumber = ''.obs;

  // Function to fetch user details from Firestore based on agentId
  Future<void> fetchUserDetails(String agentId) async {
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
        aadharCardNumber.value = userDoc['aadharCardNumber'] ?? '';
        panCardNumber.value = userDoc['panCardNumber'] ?? '';
      } else {
        print("User with agentId $agentId not found");
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }
}
