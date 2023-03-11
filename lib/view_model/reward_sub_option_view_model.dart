// import 'package:flutter/material.dart';

// import '../model/reward_sub_option.dart';
// import '../model/services/reward_sub_option_service.dart';

// class RewardSubOptionViewModel extends ChangeNotifier {
//   final RewardSubOption rewardSubOption;

//   RewardSubOptionViewModel(this.rewardSubOption);

//   String? get id => rewardSubOption.id;

//   String? get amount => rewardSubOption.amount;

//   String? get name => rewardSubOption.name;

//   int? get points => rewardSubOption.points;
// }

// class RewardSubOptionListViewModel extends ChangeNotifier {
//   List<RewardSubOptionViewModel> subOptions = <RewardSubOptionViewModel>[];
//   String documentId;
//   RewardSubOptionListViewModel({required this.documentId}) {
//     subOptions = <RewardSubOptionViewModel>[];
//   }
//   Future<void> getAll() async {
//     subOptions = await RewardSubOptionService(documentId: documentId)
//         .getAll()
//         .then((rewardSubOptions) {
//       return rewardSubOptions.map((rewardSubOption) {
//         return RewardSubOptionViewModel(rewardSubOption);
//       }).toList();
//     });
//     notifyListeners();
//   }
// }
