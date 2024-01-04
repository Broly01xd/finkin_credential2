import 'package:cloud_firestore/cloud_firestore.dart';

class AgentModel {
  final String? id;
  final String agentId;
  final String name;
  final String phone;
  final String email;
  final String aadhar;
  final String pan;
  final String address;
  final String agentType;
  final bool isFormFilled;
  final String? imageUrl;
  final String month;
  final String year;
  final bool isAccepted;

  AgentModel({
    this.id,
    required this.agentId,
    required this.isAccepted,
    required this.name,
    required this.month,
    required this.year,
    required this.phone,
    required this.email,
    required this.aadhar,
    required this.pan,
    required this.address,
    required this.agentType,
    required this.isFormFilled,
    required this.imageUrl,
  });

  toJson() {
    return {
      "AgentId": agentId,
      "Name": name,
      "Phone": phone,
      "Month": month,
      "Year": year,
      "Email": email,
      "Aadhar": aadhar,
      "Pan": pan,
      "Address": address,
      "AgentType": agentType,
      "IsFormFilled": isFormFilled,
      "ImageUrl": imageUrl,
      "IsAccepted": isAccepted,
    };
  }

  factory AgentModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return AgentModel(
      id: document.id,
      name: data["Name"],
      isAccepted: data["IsAccepted"],
      phone: data["Phone"],
      month: data["Month"],
      year: data["Year"],
      email: data["Email"],
      aadhar: data["Aadhar"],
      pan: data["Pan"],
      address: data["Address"],
      agentType: data["AgentType"],
      agentId: data['AgentId'],
      isFormFilled: data['isFormFilled'] ?? false,
      imageUrl: data['ImageUrl'],
    );
  }
}
