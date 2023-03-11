// Melakukan import cloud_firestore untuk pengambilan data
import 'package:cloud_firestore/cloud_firestore.dart';

// Melakukan import model Reward Option di folder model
import '../reward_option.dart';

class RewardOptionService {
  // Definisi variabel untuk mengambil data dari collection reward_options
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('reward_options');

  // Fungsi untuk mengambil semua data dari collection reward_options
  Future<RewardOptions> getAll() async {
    try {
      dynamic snapshot = await _collection.get();
      return RewardOptions.fromJson(snapshot.docs.map((doc) {
        return RewardOption.fromJson(doc.data() as Map<String, dynamic>);
      }).toList());
    } catch (e) {
      rethrow;
    }
  }

  // Fungsi untuk mengambil data dari collection reward_options berdasarkan id
  Future<RewardOption> get(String id) async {
    try {
      final DocumentSnapshot snapshot = await _collection.doc(id).get();
      return RewardOption.fromJson(snapshot.data() as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }
}
