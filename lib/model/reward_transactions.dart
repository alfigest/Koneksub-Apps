// Melakukan import cloud_firestore untuk pengambilan tipe variabel Timestamp
import 'package:cloud_firestore/cloud_firestore.dart';

// Definisi class RewardTransaction dalam bentuk List
class RewardTransactions {
  // Definisi variabel List
  List<RewardTransaction>? rewardTransactions;

  // Fungsi untuk melakukan convert dari JSON ke class
  RewardTransactions.fromJson(List<dynamic> data) {
    rewardTransactions = <RewardTransaction>[];
    for (var v in data) {
      rewardTransactions!.add(v);
    }
  }

  // Fungsi untuk melakukan convert dari class ke JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (rewardTransactions != null) {
      data[''] = rewardTransactions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// Definisi class RewardTransaction
class RewardTransaction {
  // Definisi variabel
  final String? id;
  final String? optionId;
  final String? subOptionId;
  final String? userId;
  final int? points;
  final Timestamp? createdAt = Timestamp.fromMillisecondsSinceEpoch(
      DateTime.now().millisecondsSinceEpoch);
  final bool? accept;

  // Constructor
  RewardTransaction({
    this.id,
    this.optionId,
    this.subOptionId,
    this.userId,
    this.points,
    this.accept = false,
  });

  // Fungsi untuk melakukan convert dari JSON ke class
  factory RewardTransaction.fromJson(Map<String, dynamic> json) =>
      RewardTransaction(
        id: json["id"],
        optionId: json["option_id"],
        subOptionId: json["sub_option_id"],
        userId: json["user_id"],
        points: json["points"],
        accept: json["accept"],
      );

  // Fungsi untuk melakukan convert dari class ke JSON
  Map<String, dynamic> toJson() => {
        "id": id,
        "option_id": optionId,
        "sub_option_id": subOptionId,
        "user_id": userId,
        "points": points,
        "created_at": createdAt,
        "accept": accept,
      };
}
