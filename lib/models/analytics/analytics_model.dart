import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsModel {
  final String? id;
  final int totalLoans;

  AnalyticsModel({
    this.id,
    required this.totalLoans,
  });
  toJson() {
    return {
      "TotalLoans": totalLoans,
    };
  }

  factory AnalyticsModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return AnalyticsModel(
      id: document.id,
      totalLoans: data["TotalLoans"],
    );
  }
}
