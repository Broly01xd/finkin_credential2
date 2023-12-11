import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoanFormController extends GetxController {
  RxString aadharImg = ''.obs;
  RxString panImg = ''.obs;
  RxString image = ''.obs;
  RxString form16Img = ''.obs;
  RxString bankImg = ''.obs;
  RxString itImg = ''.obs;
  RxString itImg2 = ''.obs;
  RxBool isLoginAccessGranted = RxBool(false);

  final formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController aadharCardController = TextEditingController();
  final TextEditingController panCardController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController form16Controller = TextEditingController();
  final TextEditingController bankImgController = TextEditingController();
  final TextEditingController itImgController = TextEditingController();
  final TextEditingController itImg2Controller = TextEditingController();
  final TextEditingController incomeController = TextEditingController();
  final TextEditingController income2Controller = TextEditingController();

  RxBool isPermissionGranted = false.obs;
  RxString employeeType = ''.obs;

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

  void updatePermissionGranted(bool value) {
    isPermissionGranted.value = value;
  }

  bool getPermissionGranted() {
    return isPermissionGranted.value;
  }

  void grantLoginAccess() {
    isLoginAccessGranted.value = true;
  }

  void resetLoginAccess() {
    isLoginAccessGranted.value = false;
  }

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

  void updateItImgImageUrl(String imageUrl) {
    itImg.value = imageUrl;
  }

  void updateItImg2ImageUrl(String imageUrl) {
    itImg2.value = imageUrl;
  }

  void updateForm16ImgImageUrl(String imageUrl) {
    form16Img.value = imageUrl;
  }

  void updateBankImgImageUrl(String imageUrl) {
    bankImg.value = imageUrl;
  }
}
