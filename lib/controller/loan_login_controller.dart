// import 'dart:async';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class LoanLoginController extends GetxController {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   var phoneNo = TextEditingController();
//   var otp = "".obs;
//   var isOtpSent = false.obs;
//   var statusMessage = "".obs;
//   var statusMessageColor = Colors.black.obs;
//   var isButtonClickable = true.obs;
//   var firebaseVerificationId = "";
//   Timer? _timer;
//   RxString agentId = ''.obs;
//   RxString userId = ''.obs;
//   final TextEditingController otpController = TextEditingController();
//
//   static LoanLoginController get instance => Get.find();
//
//   LoanLoginController() {
//     initAuthListener();
//   }
//
//   @override
//   void onInit() async {
//     super.onInit();
//   }
//
//   void initAuthListener() {
//     _auth.authStateChanges().listen((User? user) {
//       if (user != null) {
//         userId.value = user.uid;
//       } else {
//         userId.value = '';
//       }
//     });
//   }
//
//   String verificationId = ''; // Added this line
//
//   void startTimer() {
//     _timer = Timer(Duration(seconds: 30), () {
//       isButtonClickable.value = true;
//     });
//   }
//
//   getOtp() async {
//     isButtonClickable.value = false;
//     FirebaseAuth.instance.verifyPhoneNumber(
//       phoneNumber: '+91' + phoneNo.text,
//       verificationCompleted: (PhoneAuthCredential credential) {},
//       verificationFailed: (FirebaseAuthException e) {},
//       codeSent: (String verificationId, int? resendToken) {
//         firebaseVerificationId = verificationId; // Updated this line
//         isOtpSent.value = true;
//         statusMessage.value = "OTP sent to +91" + phoneNo.text;
//         startTimer();
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {},
//     );
//   }
//
//   verifyOTP({required String newPhoneNumber}) async {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     try {
//       statusMessage.value = "Verifying... " + otp.value;
//       statusMessageColor = Colors.green.obs;
//
//       // Verify the OTP
//       await auth.signInWithCredential(PhoneAuthProvider.credential(
//         verificationId: firebaseVerificationId,
//         smsCode: otp.value,
//       ));
//
//       // Create a temporary link with an expiry time
//       String temporaryLink = createTemporaryLink(newPhoneNumber, expiryTime);
//
//       // Store the link information on your server
//
//       // Perform actions needed with the verified phone number
//       // ...
//
//       // Remove the link automatically after expiry time
//       removeTemporaryLink(temporaryLink);
//
//       // Clear the verification ID and OTP after verification
//       firebaseVerificationId = '';
//       otp.value = '';
//
//       // Inform the user about successful verification
//     } catch (e) {
//       statusMessage.value = "Invalid OTP";
//       statusMessageColor = Colors.red.obs;
//     }
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
// }
