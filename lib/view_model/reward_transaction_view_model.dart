// import 'package:flutter/material.dart';

// import '../model/reward_transactions.dart';
// import '../model/services/reward_transaction_service.dart';

// class RewardTransactionViewModel extends ChangeNotifier {
//   final RewardTransaction rewardTransaction;

//   RewardTransactionViewModel(this.rewardTransaction);

//   String? get id => rewardTransaction.id;

//   String? get optionId => rewardTransaction.optionId;

//   String? get subOptionId => rewardTransaction.subOptionId;

//   String? get userId => rewardTransaction.userId;

//   int? get points => rewardTransaction.points;

//   String? get createdAt => rewardTransaction.createdAt;
// }

// class RewardTransactionListViewModel extends ChangeNotifier {
//   List<RewardTransactionViewModel> transactions =
//       <RewardTransactionViewModel>[];
//   String documentId;
//   RewardTransactionListViewModel({required this.documentId}) {
//     transactions = <RewardTransactionViewModel>[];
//   }
//   Future<void> getAll() async {
//     transactions =
//         await RewardTransactionService.getAll().then((rewardTransactions) {
//       return rewardTransactions.map((rewardTransaction) {
//         return RewardTransactionViewModel(rewardTransaction);
//       }).toList();
//     });
//     notifyListeners();
//   }
// }
