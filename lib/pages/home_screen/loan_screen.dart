import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_credential/controller/info_controller.dart';
import 'package:finkin_credential/models/loan_model/loan_model.dart';
import 'package:finkin_credential/pages/loan_information/infodisplay.dart';
import 'package:finkin_credential/res/app_color/app_color.dart';
import 'package:finkin_credential/res/constants/enums/enums.dart';
import 'package:finkin_credential/res/image_asset/image_asset.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final UserInfoController userInfoController = Get.put(UserInfoController());
  final CollectionReference loansCollection =
      FirebaseFirestore.instance.collection('Loan');
  final CollectionReference agentsCollection =
      FirebaseFirestore.instance.collection('Agents');

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
                  .where('AgentId', isEqualTo: id)
                  .snapshots()
              : loansCollection.where('AgentId', isEqualTo: id).snapshots(),
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
                    imageAsset: loan.userImage,
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
                              InfoDisplay(documentId: documentId),
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
    String id = loginController.agentId.value;
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
            return const CircularProgressIndicator(
              color: AppColor.primary,
            );
          }

          List<LoanModel> approvedLoans = snapshot.data!.docs
              .map((DocumentSnapshot doc) => LoanModel.fromSnapshot(
                  doc as DocumentSnapshot<Map<String, dynamic>>))
              .toList();

          String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';

          return FutureBuilder<QuerySnapshot>(
            future: agentsCollection
                .where('AgentId', isEqualTo: currentUserUid)
                .get(),
            builder: (context, agentSnapshot) {
              if (agentSnapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(
                  color: Colors.blue, // Change color as needed
                );
              }

              if (agentSnapshot.hasError) {
                return Text(
                    'Error fetching agent data: ${agentSnapshot.error}');
              }

              // Check if the document exists
              if (agentSnapshot.data!.docs.isEmpty) {
                return const Text('Agent data not found');
              }

              // Extract data from the 'Agents' collection
              Map<String, dynamic>? agentData = agentSnapshot.data!.docs.first
                  .data() as Map<String, dynamic>?;

              // Check if 'agentData' is not null before using it
              if (agentData == null) {
                return const Text('Agent data is null');
              }

              // Assuming 'AgentId' is a field in 'agentData'
              String agentIdFromFirestore = agentData['AgentId'];

              // Check if the 'AgentId' matches the current user's ID
              if (agentIdFromFirestore == currentUserUid) {
                // Now you can use 'agentData' to access fields from the 'Agents' collection
                // For example, assuming there is a field 'month' in 'Agents'
                String agentMonth = agentData['Month'];
                String agentYear = agentData['Year'];

                // Rest of your UI building logic...
                return Stack(
                  children: [
                    Container(
                      height: 200,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                        color: AppColor.primary, // Change color as needed
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 5,
                      right: 0,
                      child: AppBar(
                        toolbarHeight: 75.0,
                        title: const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 30.0, bottom: 10.0),
                            child: Column(
                              children: [
                                Text(
                                  'Approved Loans',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(height: 10.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "This Month ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "This Year",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
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
                                color: Colors.white,
                                width: 1.0,
                              ),
                            ),
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: agentMonth,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: ' /',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const TextSpan(
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
                                color: Colors.white,
                                width: 1.0,
                              ),
                            ),
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: agentYear,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: ' /',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const TextSpan(
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
              } else {
                // Current user is not the agent, handle accordingly
                return const Text('Current user is not the agent.');
              }
            },
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
    logo: '',
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
    logo: '',
  ),
];
