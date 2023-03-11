// Melakukan import beberapa file yang dibutuhkan
import 'package:flutter/cupertino.dart';
import 'package:waste_application/model/reward_transactions.dart';
import 'package:waste_application/model/services/user_service.dart';
import '../data/response/api_response.dart';
import '../model/reward_option.dart';
import '../model/reward_sub_option.dart';
import '../model/services/reward_option_service.dart';
import '../model/services/reward_sub_option_service.dart';
import '../model/services/reward_transaction_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class RedeemViewViewModel with ChangeNotifier {
  // Variabel service untuk mengakses data di firebase
  final _rewardOptionService = RewardOptionService();
  final _userService = UserDetailService();
  final _auth = FirebaseAuth.instance;

  // Variabel untuk menampung data reward option
  ApiResponse<RewardOptions> rewardOptions =
      ApiResponse<RewardOptions>.loading('Loading');

  // Variabel untuk menampung data reward sub option
  ApiResponse<RewardSubOptions> rewardSubOptions =
      ApiResponse<RewardSubOptions>.loading('Loading');

  // Fungsi untuk menyimpan data reward option
  setRewardOptions(ApiResponse<RewardOptions> value) {
    rewardOptions = value;
    notifyListeners();
  }

  // Fungsi untuk menyimpan data reward sub option
  setRewardSubOptions(ApiResponse<RewardSubOptions> value) {
    rewardSubOptions = value;
    notifyListeners();
  }

  // Fungsi untuk mengambil data reward option
  Future<void> fetchRewardOptionsApi() async {
    await _rewardOptionService.getAll().then((value) {
      setRewardOptions(ApiResponse<RewardOptions>.completed(value));
    }).catchError((e) {
      setRewardOptions(ApiResponse<RewardOptions>.error(e.toString()));
    });
  }

  // Fungsi untuk mengambil data reward sub option berdasarkan id
  Future<void> fetchRewardSubOptionsApi(String docId) async {
    final rewardSubOptionService = RewardSubOptionService(documentId: docId);
    await rewardSubOptionService.getAll().then((value) {
      setRewardSubOptions(ApiResponse<RewardSubOptions>.completed(value));
    }).catchError((e) {
      setRewardSubOptions(ApiResponse<RewardSubOptions>.error(e.toString()));
    });
  }

  // Fungsi untuk melakukan redeem reward
  Future<void> addRewardTransactionApi(String optionId, String subOptionId,
      String userId, int points, int userPoint) async {
    try {
      var uuid = const Uuid();
      final data = RewardTransaction(
          id: uuid.v1(),
          optionId: optionId,
          subOptionId: subOptionId,
          userId: userId,
          points: points);
      await RewardTransactionService.add(data).then((value) async {
        await _userService.update(userId, userPoint);
        notifyListeners();
      }).catchError((e) {
        print(e);
      });
    } catch (e) {
      rethrow;
    }
  }
}
