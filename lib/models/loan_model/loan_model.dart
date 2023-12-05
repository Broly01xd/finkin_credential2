import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_credential/res/constants/enums/enums.dart';
import 'package:flutter/material.dart';

class LoanModel {
  final String? id;
  final String userId;
  final String agentId;
  final String agentName;
  final String aadharImg;
  final String panImg;
  final String userName;
  final String loanType;
  final DateTime date;
  final LoanStatus status;
  final String phone;
  final String email;
  final String panNo;
  final String aadharNo;
  final String address;
  final String image;

  LoanModel(
      {this.id,
      required this.userId,
        required this.agentId,
        required this.agentName,
      required this.userName,
      required this.aadharImg,
      required this.panImg,
      required this.loanType,
      required this.date,
      required this.phone,
      required this.address,
      required this.email,
      required this.aadharNo,
      required this.panNo,
      required this.image,
      this.status = LoanStatus.pending});

  toJson() {
    return {
      "UserId": userId,
      "AgentId": agentId,
      "UserName": userName,
      "AgentName": agentName,
      "AadharImg": aadharImg,
      "Email": email,
      "LoanType": loanType,
      "Date": date,
      "Phone": phone,
      "PanImg": panImg,
      "Pan": panNo,
      "Address": address,
      "AadharNo": aadharNo,
      "Status": status.name,
      "Image": image,
    };
  }

  factory LoanModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return LoanModel(
      id: document.id,
      userId: data?["UserId"] ?? "",
      agentId: data?["AgentId"] ?? "",
      userName: data?["UserName"] ?? "",
      agentName: data?["AgentName"] ?? "",
      phone: data?["Phone"] ?? "",
      email: data?["Email"] ?? "",
      aadharNo: data?["AadharNo"] ?? "",
      panNo: data?["PanNo"] ?? "",
      address: data?["Address"] ?? "",
      status: _getStatusFromString(data?["Status"]),
      aadharImg: data?['AadharImg'] ?? "",
      panImg: data?['PanImg'] ?? "",
      loanType: data?['LoanType'] ?? "",
      date: (data?['Date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      image: data?['Image'] ?? "",
    );
  }

  static LoanStatus _getStatusFromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return LoanStatus.pending;
      case 'approved':
        return LoanStatus.approved;
      case 'denied':
        return LoanStatus.denied;
      default:
        return LoanStatus.pending; // or throw an error if appropriate
    }
  }

  IconData get icon => loanStatusIcons[status] ?? Icons.no_accounts;
  final Map<LoanStatus, IconData> loanStatusIcons = {
    LoanStatus.pending: Icons.hourglass_top_outlined,
    LoanStatus.approved: Icons.check_circle,
    LoanStatus.denied: Icons.cancel_outlined
  };
}
