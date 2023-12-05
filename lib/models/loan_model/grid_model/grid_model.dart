import 'package:finkin_credential/res/image_asset/image_asset.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../pages/loan_information/loan_form.dart';

class Category {
  final String imagePath;
  final String text;
  final void Function(BuildContext)? onTap;
  Category({required this.imagePath, required this.text, required this.onTap});
}

List<Category> categories = [
  
  Category(
    imagePath: ImageAsset.educationloan,
    text: 'Business Loans ',
    onTap: (BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoanForm(
            title: 'Business Loan',
            agentId: '',
          ),
        ),
      );
    },
  ),
  Category(
    imagePath: ImageAsset.loan5,
    text: 'Education Loan',
    onTap: (BuildContext context) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LoanForm(
              agentId: user.uid,
              title: 'Education Loan',
            ),
          ),
        );
      }
    },
  ),
  
  
  Category(
    imagePath: ImageAsset.bussinessloan,
    text: 'Home Loan',
    onTap: (BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoanForm(
            title: 'Home Loan',
            agentId: '',
          ),
        ),
      );
    },
  ),
 
  Category(
    imagePath: ImageAsset.pl,
    text: ' Personal Loans',
    onTap: (BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoanForm(
            title: 'Personal Loan',
            agentId: '',
          ),
        ),
      );
    },
  ),
   Category(
    imagePath: ImageAsset.homeloan,
    text: 'Bank Loan',
    onTap: (BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoanForm(
            title: 'Bank Loan',
            agentId: '',
          ),
        ),
      );
    },
  ),
   Category(
    imagePath: ImageAsset.jair,
    text: ' Car Loans',
    onTap: (BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoanForm(
            title: 'Car Loan',
            agentId: '',
          ),
        ),
      );
    },
  ),
 
];
