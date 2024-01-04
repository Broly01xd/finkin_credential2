import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AgentFormController extends GetxController {
  RxString selectedAgentType = ''.obs;
  RxString imageUrl = ''.obs;
  final formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController aadharCardController = TextEditingController();
  final TextEditingController panCardController = TextEditingController();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  static const String nameRegex = r'^[A-Za-z\s]+$';
  static const String phoneNumberRegex = r'^\+?[0-9]+$';
  static const String addressRegex = r'^[A-Za-z0-9\s\-#,./]+$';
  static const String panCardRegex = r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$';
  static const String aadharCardRegex = r'^\d{12}$';
  static const String emailRegex =
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';

  bool validateForm() {
    if (formKey.currentState!.validate()) {
      Get.snackbar('Success', 'Submitting Form');

      return true;
    } else {
      Get.snackbar('Error', 'Please fix the errors in the form');
      return false;
    }
  }

  void setSelectedAgentType(String type) {
    selectedAgentType.value = type;
  }
}
