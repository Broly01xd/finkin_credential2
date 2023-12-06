import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserInfoController extends GetxController {
  var fullName = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;
  var dob = ''.obs;
  var address = ''.obs;
  var imageUrl = ''.obs;
  var userid = ''.obs;
  var status = ''.obs;
  var currentStep = 1.obs;
  var isLoading = true.obs;

  Future<void> fetchUserDetails(String agentId) async {
    try {
      isLoading(true);
      print("Fetching user details for agentId: $agentId");

      final querySnapshot = await FirebaseFirestore.instance
          .collection('Loan')
          .where('AgentId', isEqualTo: agentId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first.data();
        print("User details fetched successfully: $userDoc");
        address.value = userDoc['Address'] ?? '';
        fullName.value = userDoc['UserName'] ?? '';
        email.value = userDoc['Email'] ?? '';
        phone.value = userDoc['Phone'] ?? '';
        userid.value = userDoc['AgentId'] ?? '';
        imageUrl.value = userDoc['AadharImg'] ?? '';
        status.value = userDoc['Status'] ?? '';
        _updateCurrentStep(status.value);
        // dob.value = userDoc['Date'] ?? '';
      } else {
        print("User with agentId $agentId not found");
      }
    } catch (e) {
      print("Error fetching user details: $e");
    } finally {
      isLoading(false);
    }
  }

  void _updateCurrentStep(String status) {
    switch (status) {
      case 'pending':
        currentStep.value = 3;
        break;
      case 'approved':
        currentStep.value = 4;
        break;
      case 'denied':
        currentStep.value = 5;
        break;
      default:
        currentStep.value = 1; // Default to the first step
    }
  }
}
