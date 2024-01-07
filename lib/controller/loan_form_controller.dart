import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoanFormController extends GetxController {
  RxString aadharImg =
      'https://firebasestorage.googleapis.com/v0/b/finkin-credential.appspot.com/o/Logo%2Fimages.jpg?alt=media&token=39facc7b-ef5d-42c5-a31b-dbafff25c7b4'
          .obs;
  RxString panImg =
      'https://firebasestorage.googleapis.com/v0/b/finkin-credential.appspot.com/o/Logo%2Fimages.jpg?alt=media&token=39facc7b-ef5d-42c5-a31b-dbafff25c7b4'
          .obs;
  RxString image =
      'https://firebasestorage.googleapis.com/v0/b/finkin-credential.appspot.com/o/Logo%2Fimages.jpg?alt=media&token=39facc7b-ef5d-42c5-a31b-dbafff25c7b4'
          .obs;
  RxString form16Img =
      'https://firebasestorage.googleapis.com/v0/b/finkin-credential.appspot.com/o/Logo%2Fimages.jpg?alt=media&token=39facc7b-ef5d-42c5-a31b-dbafff25c7b4'
          .obs;
  RxString bankImg =
      'https://firebasestorage.googleapis.com/v0/b/finkin-credential.appspot.com/o/Logo%2Fimages.jpg?alt=media&token=39facc7b-ef5d-42c5-a31b-dbafff25c7b4'
          .obs;
  RxString itImg =
      'https://firebasestorage.googleapis.com/v0/b/finkin-credential.appspot.com/o/Logo%2Fimages.jpg?alt=media&token=39facc7b-ef5d-42c5-a31b-dbafff25c7b4'
          .obs;
  RxString itImg2 =
      'https://firebasestorage.googleapis.com/v0/b/finkin-credential.appspot.com/o/Logo%2Fimages.jpg?alt=media&token=39facc7b-ef5d-42c5-a31b-dbafff25c7b4'
          .obs;
  RxString userImg =
      'https://firebasestorage.googleapis.com/v0/b/finkin-credential.appspot.com/o/Logo%2Fimages.jpg?alt=media&token=39facc7b-ef5d-42c5-a31b-dbafff25c7b4'
          .obs;
  RxBool isLoginAccessGranted = RxBool(false);
  //dont delete Logo folder in storage and if somehow deleted manually create following url image
  //logo image is manually created in storage and some

  String logo =
      'https://firebasestorage.googleapis.com/v0/b/finkin-credential.appspot.com/o/Logo%2Ffink.jpg?alt=media&token=7ebd240b-5807-49a4-ae4d-92a5c1af9d56';

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
