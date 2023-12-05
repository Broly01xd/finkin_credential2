import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoanFormController extends GetxController {
  RxString aadharImg = ''.obs;
  RxString panImg = ''.obs;
  RxString image = ''.obs;
  final formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController aadharCardController = TextEditingController();
  final TextEditingController panCardController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  static const String nameRegex = r'^[A-Za-z\s]+$';
  static const String phoneNumberRegex = r'^\+?[0-9]+$';
  static const String addressRegex = r'^[A-Za-z0-9\s\-#,./]+$';
  static const String panCardRegex = r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$';
  static const String aadharCardRegex = r'^\d{12}$';
  static const String emailRegex =
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
  static const String pinCodeRegex = r'^\d{6}$';
  static const String dateOfBirthRegex = r'^\d{2}/\d{2}/\d{4}$';

  bool validateForm() {
    if (formKey.currentState!.validate()) {
      Get.snackbar('Success', 'Submitting Form');

      return true;
    } else {
      Get.snackbar('Error', 'Please fix the errors in the form');
      return false;
    }
  }

  void updateAadharImageUrl(String imageUrl) {
    aadharImg.value = imageUrl;
  }

  void updatePanImageUrl(String imageUrl) {
    panImg.value = imageUrl;
  }

  void updateImageImageUrl(String imageUrl) {
    aadharImg.value = imageUrl;
  }
}
