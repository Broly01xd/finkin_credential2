import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_credential/models/loan_model/loan_model.dart';
import 'package:finkin_credential/pages/loan_information/infodisplay.dart';
import 'package:finkin_credential/res/app_color/app_color.dart';
import 'package:finkin_credential/res/constants/enums/enums.dart';
import 'package:finkin_credential/res/image_asset/image_asset.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/login_controller.dart';
import '../../shared/widgets/Loan_Tracking_widget/loan_track.dart';

class LoanScreen extends StatefulWidget {
  final String title;
  final LoanStatus? status;
  const LoanScreen({Key? key, required this.title, this.status})
      : super(key: key);

  @override
  State<LoanScreen> createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {
  final LoginController loginController = Get.put(LoginController());
  final CollectionReference loansCollection =
      FirebaseFirestore.instance.collection('Loan');

  @override
  Widget build(BuildContext context) {
    String id = loginController.agentId.value;
    print(id);
    return Scaffold(
      appBar: widget.title == 'Approved'
          ? _buildApprovedAppBar()
          : _buildRegularAppBar(),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: widget.title == 'Approved'
              ? loansCollection
                  .where('Status', isEqualTo: LoanStatus.approved.name)
                  .where('AgentId', isEqualTo: id)
                  .snapshots()
              : loansCollection.where('AgentId', isEqualTo: id).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            List<LoanModel> loanItems = snapshot.data!.docs
                .map((DocumentSnapshot doc) => LoanModel.fromSnapshot(
                    doc as DocumentSnapshot<Map<String, dynamic>>))
                .toList();

            return ListView.builder(
              itemCount: loanItems.length,
              itemBuilder: (context, index) {
                final loan = loanItems[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: LoanTrack(
                    imageAsset: loan.panImg,
                    userName: loan.userName,
                    loanType: loan.loanType,
                    date: loan.date,
                    icon: loan.icon,
                    status: loan.status,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InfoDisplay(),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildRegularAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
          color: AppColor.primary,
        ),
        child: AppBar(
          title: Center(
            child: Text(
              widget.title,
              style: const TextStyle(color: AppColor.textLight),
            ),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
    );
  }

  PreferredSizeWidget _buildApprovedAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(280.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: loansCollection
            .where('Status', isEqualTo: LoanStatus.approved.name)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          List<LoanModel> approvedLoans = snapshot.data!.docs
              .map((DocumentSnapshot doc) => LoanModel.fromSnapshot(
                  doc as DocumentSnapshot<Map<String, dynamic>>))
              .toList();

          return Stack(
            children: [
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                  color: AppColor.primary,
                ),
              ),
              Positioned(
                top: 10,
                left: 5,
                right: 0,
                child: AppBar(
                  toolbarHeight: 75.0,
                  title: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
                      child: Column(
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(color: AppColor.textLight),
                          ),
                          const SizedBox(height: 10.0),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "This Month ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.textLight,
                                ),
                              ),
                              Text(
                                "This Year",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.textLight,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  automaticallyImplyLeading: false,
                  backgroundColor: const Color.fromARGB(0, 236, 75, 75),
                  elevation: 0,
                ),
              ),
              Positioned(
                bottom: 22,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 80,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: AppColor.textLight,
                          width: 1.0,
                        ),
                      ),
                      child: Center(
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: '21',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              TextSpan(
                                text: ' /',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.textLight,
                                ),
                              ),
                              TextSpan(
                                text: '25',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: AppColor.textLight,
                          width: 1.0,
                        ),
                      ),
                      child: Center(
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: '600',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.icon,
                                ),
                              ),
                              TextSpan(
                                text: ' /',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.textLight,
                                ),
                              ),
                              TextSpan(
                                text: '700',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

final loanItems = [
  LoanModel(
    image: ImageAsset.pop,
    userName: 'Roshan',
    loanType: 'Personal loan',
    date: DateTime.now(),
    status: LoanStatus.approved,
    userId: '',
    agentName: '',
    panImg: '',
    aadharImg: '',
    phone: '',
    address: '',
    email: '',
    aadharNo: '',
    panNo: '',
    agentId: '',
    isGranted: true,
    form16img: '',
    bankImg: '',
    income: '',
    itReturnImg: '',
    secondImg: '',
    monthlyIncome: '',
  ),
  LoanModel(
    image: ImageAsset.pop,
    userName: 'Roshan',
    loanType: 'Personal loan',
    date: DateTime.now(),
    status: LoanStatus.denied,
    userId: '',
    agentName: '',
    aadharImg: '',
    panImg: '',
    phone: '',
    address: '',
    email: '',
    aadharNo: '',
    panNo: '',
    agentId: '',
    isGranted: true,
    form16img: '',
    bankImg: '',
    income: '',
    itReturnImg: '',
    secondImg: '',
    monthlyIncome: '',
  ),
];
