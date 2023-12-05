import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_credential/models/loan_model/loan_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LaonRepository extends GetxController {
  static LaonRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createLoan(LoanModel loan) async {
    try {
      print("Attempting to add loan: ${loan.toJson()}");
      await _db.collection("Loan").add(loan.toJson()).then(
        (val) {
          Get.snackbar("Success", "your form has been recorded",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.withOpacity(0.1),
              colorText: Colors.green);
        },
      ).catchError((error, stackTrace) {
        print("next");
        print(error);
        print('error is');
        Get.snackbar("Error", "Something went wrong. Try again",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green);
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<bool> isLoanFormFilled(String loanId) async {
    try {
      CollectionReference loanCollection =
          FirebaseFirestore.instance.collection('Loan');
      QuerySnapshot querySnapshot =
          await loanCollection.where('LoanId', isEqualTo: loanId).get();
      print("loan id is");
      print(loanId);
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
}
