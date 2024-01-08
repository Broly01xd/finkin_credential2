import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_credential/models/loan_model/loan_model.dart';
import 'package:finkin_credential/pages/agent_screen/agent.dart';
import 'package:finkin_credential/res/app_color/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/agent_model/agent_model.dart';
import '../pages/agent_verification/check_login.dart';
import '../pages/agent_verification/verification.dart';
import '../pages/home_screen/bottom_nav.dart';
import '../pages/verification_screen/user_screen.dart';
import '../repository/agent_repository/agent_repository.dart';
import '../repository/loan_repository/loan_repository.dart';

class LoginController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isUserSelected = true.obs;

  var showPrefix = false.obs;
  var isLogin = true;
  var phoneNo = "".obs;
  var otp = "".obs;
  var isOtpSent = false.obs;
  var resendAfter = 30.obs;
  var resendOTP = false.obs;
  var firebaseVerificationId = "";
  var statusMessage = "".obs;
  var statusMessageColor = Colors.black.obs;
  var isButtonClickable = true.obs;

  Timer? _timer;
  static LoginController get instance => Get.find();
  final agentRepo = Get.put(AgentRepository());
  final loanRepo = Get.put(LaonRepository());
  var timer;
  RxString agentId = ''.obs;

  LoginController() {
    initAuthListener();
  }

  void setIsUserSelected(bool isSelected) {
    isUserSelected.value = isSelected;
    update();
  }

  void startTimer() {
    _timer = Timer(const Duration(seconds: 30), () {
      isButtonClickable.value = true;
    });
  }

  Future<void> getOtp() async {
    try {
      if (isUserSelected.value) {
        bool isUserAvailable = await isUserExist(phoneNo.value);

        if (isUserAvailable) {
          isButtonClickable.value = false;
          FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: '+91${phoneNo.value}',
            verificationCompleted: (PhoneAuthCredential credential) {},
            verificationFailed: (FirebaseAuthException e) {},
            codeSent: (String verificationId, int? resendToken) {
              firebaseVerificationId = verificationId;
              isOtpSent.value = true;
              statusMessage.value = "OTP sent to +91${phoneNo.value}";
              startResendOtpTimer();
              isButtonClickable.value = false;
              startTimer();
            },
            codeAutoRetrievalTimeout: (String verificationId) {},
          );
        } else {
          Get.snackbar(
            "User Not Found",
            "Please contact an agent to register.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColor.errorbar.withOpacity(0.1),
            colorText: AppColor.errorbar,
          );
        }
      } else if (!isUserSelected.value) {
        isButtonClickable.value = false;
        FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '+91${phoneNo.value}',
          verificationCompleted: (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException e) {},
          codeSent: (String verificationId, int? resendToken) {
            firebaseVerificationId = verificationId;
            isOtpSent.value = true;
            //  statusMessage.value = "OTP sent to +91" + phoneNo.value;
            statusMessage.value = "OTP sent to +91${phoneNo.value}";
            startResendOtpTimer();
            isButtonClickable.value = false;
            startTimer();
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      }
    } catch (error) {
      print("Error while checking user existence: $error");
    }
  }

  Future<bool> isUserExist(String phoneNumber) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('phoneNumberCollection')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();

      isUserSelected.value = querySnapshot.docs.isNotEmpty;
      return querySnapshot.docs.isNotEmpty;
    } catch (error) {
      print("Error checking user existence: $error");
      return false;
    }
  }

  resendOtp() async {
    resendOTP.value = false;
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91' + phoneNo.value,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        firebaseVerificationId = verificationId;
        isOtpSent.value = true;
        statusMessage.value = "OTP re-sent to +91" + phoneNo.value;
        startResendOtpTimer();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  verifyOTP({required String agentId}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      statusMessage.value = "Verifying... " + otp.value;
      statusMessageColor = AppColor.textPrimary.obs;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: firebaseVerificationId, smsCode: otp.value);

      await auth.signInWithCredential(credential);
      String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
      agentId = currentUserUid!;
      bool isUserAvailable = await isUserExist(phoneNo.value);

      if (isUserAvailable) {
        await updateLoanDocument(currentUserUid);

        Get.to(() => const UserScreen());
      } else {
        bool isFormFilled = await agentRepo.isAgentFormFilled(agentId);

        if (isFormFilled) {
          await checkIsAcceptedStatus(phoneNo.value);
        } else {
          Get.to(() => const AgentPage());
        }
      }
    } catch (e) {
      statusMessage.value = "Invalid OTP";
      statusMessageColor = AppColor.textPrimary.obs;
    } finally {
      isOtpSent.value = false;
      if (_timer != null && _timer!.isActive) {
        _timer!.cancel();
      }
      if (timer != null && timer.isActive) {
        timer.cancel();
      }
      resendAfter.value = 30;
      isButtonClickable.value = true;
    }
  }

  Future<void> checkIsAcceptedStatus(String phoneNumber) async {
    try {
      // Retrieve the agent document from Firestore where agentId matches the logged-in agent's ID
      QuerySnapshot agentDocs = await FirebaseFirestore.instance
          .collection('Agents')
          .where('Phone', isEqualTo: phoneNumber)
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
        print('Agent document not found for ID: ');
        // You may want to display an error message or handle it accordingly
      } else {
        // Handle the case when there are multiple documents with the same agentId
        print('Multiple agent documents found for ID: ');
        // You may want to display an error message or handle it accordingly
      }
    } catch (e) {
      // Handle any potential errors during the Firestore operation
      print('Error checking isAccepted status: $e');
      // You may want to display an error message or handle it accordingly
    }
  }

  Future<void> storeAgentIdInFirestore(String agentId) async {
    try {
      String? uid = _auth.currentUser?.uid;

      if (uid != null) {
        CollectionReference agentsCollection =
            FirebaseFirestore.instance.collection('agents');

        await agentsCollection.doc(uid).set({
          'agentId': agentId,
        });
      }
    } catch (e) {
      print("Error storing agentId in Firestore: $e");
    }
  }

  startResendOtpTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendAfter.value != 0) {
        resendAfter.value--;
      } else {
        resendAfter.value = 30;
        resendOTP.value = true;
        timer.cancel();
      }
      update();
    });
  }

  void initAuthListener() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        agentId.value = user.uid;
      } else {
        agentId.value = '';
      }
    });
  }

  Future<void> createAgent(AgentModel agent) async {
    await agentRepo.createAgent(agent);
    Get.to(() => const CheckLogin());
  }

  Future<void> createLoan(LoanModel loan) async {
    try {
      await loanRepo.createLoan(loan);
      Get.to(() => const BottomNavBar());
    } catch (error) {
      print('Error creating loan: $error');
      Get.snackbar(
        "Error",
        "Something went wrong while creating the loan. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.errorbar.withOpacity(0.1),
        colorText: AppColor.errorbar,
      );
    }
  }

  Future<void> updateLoanDocument(String userId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Loan')
          .where('Phone', isEqualTo: phoneNo.value)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String documentId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('Loan')
            .doc(documentId)
            .update({
          'UserId': userId,
        });
      }
    } catch (error) {
      print("Error updating Loan document: $error");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
