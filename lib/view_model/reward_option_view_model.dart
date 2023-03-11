// import 'package:flutter/material.dart';
// import 'package:waste_application/model/reward_option.dart';

// import '../model/services/reward_option_service.dart';

// class RewardOptionViewModel extends ChangeNotifier {
//   final RewardOption rewardOption;

//   RewardOptionViewModel(this.rewardOption);

//   String? get option => rewardOption.option;

//   String? get description => rewardOption.description;

//   String? get id => rewardOption.id;
// }

// class RewardOptionListViewModel extends ChangeNotifier {
//   List<RewardOptionViewModel> options = <RewardOptionViewModel>[];

//   Future<void> getAll() async {
//     options = await RewardOptionService.getAll().then((rewardOptions) {
//       return rewardOptions.map((rewardOption) {
//         return RewardOptionViewModel(rewardOption);
//       }).toList();
//     });
//     notifyListeners();
//   }
// }
