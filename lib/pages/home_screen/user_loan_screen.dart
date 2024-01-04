import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_credential/controller/info_controller.dart';
import 'package:finkin_credential/models/loan_model/loan_model.dart';
import 'package:finkin_credential/res/app_color/app_color.dart';
import 'package:finkin_credential/res/constants/enums/enums.dart';
import 'package:finkin_credential/res/image_asset/image_asset.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/login_controller.dart';
import '../../shared/widgets/Loan_Tracking_widget/loan_track.dart';
import '../loan_information/user_info_display.dart';

class UserLoanScreen extends StatefulWidget {
  final String title;
  final LoanStatus? status;
  const UserLoanScreen({Key? key, required this.title, this.status})
      : super(key: key);

  @override
  State<UserLoanScreen> createState() => _UserLoanScreenState();
}

class _UserLoanScreenState extends State<UserLoanScreen> {
  final LoginController loginController = Get.put(LoginController());
  final UserInfoController userInfoController = Get.put(UserInfoController());
  final CollectionReference loansCollection =
      FirebaseFirestore.instance.collection('Loan');

  @override
  void initState() {
    super.initState();
    String id = loginController.agentId.value;
    userInfoController.fetchAgentDetails(id);

    print("Image URL: ${userInfoController.userid.value}");
  }

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
                  .where('UserId', isEqualTo: id)
                  .snapshots()
              : loansCollection.where('UserId', isEqualTo: id).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(
                color: AppColor.primary,
              );
            }
            final data = snapshot.requireData;
            List<LoanModel> loanItems = snapshot.data!.docs
                .map((DocumentSnapshot doc) => LoanModel.fromSnapshot(
                    doc as DocumentSnapshot<Map<String, dynamic>>))
                .toList();

            return ListView.builder(
              itemCount: loanItems.length,
              itemBuilder: (context, index) {
                final loan = loanItems[index];
                final documentId = data.docs[index].id;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: LoanTrack(
                    imageAsset: userInfoController.userImage.value,
                    userName: loan.userName,
                    loanType: loan.loanType,
                    date: loan.date,
                    icon: loan.icon,
                    status: loan.status,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UserInfoDisplay(documentId: documentId),
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
            return CircularProgressIndicator(
              color: AppColor.primary,
            );
          }

          List<LoanModel> approvedLoans = snapshot.data!.docs
              .map((DocumentSnapshot doc) => LoanModel.fromSnapshot(
                  doc as DocumentSnapshot<Map<String, dynamic>>))
              .toList();

          return Stack(
            children: [
              Container(
                height: 90,
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
                  title: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                      child: Column(
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(color: AppColor.textLight),
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
    userImage: '',
    nationality: '',
    pin: '',
    empType: '',
    panNoCpy: '',
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
    userImage: '',
    nationality: '',
    pin: '',
    empType: '',
    panNoCpy: '',
  ),
];
