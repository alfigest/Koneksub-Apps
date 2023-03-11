// Melakukan import cloud_firestore untuk pengambilan data
import 'package:cloud_firestore/cloud_firestore.dart';

// Melakukan import model Sub Reward Option di folder model
import '../reward_sub_option.dart';

class RewardSubOptionService {
  // Variabel document ID untuk mengambil data dari collection reward_sub_options
  final String documentId;

  // Variabel reference untuk mengambil data dari collection reward_sub_options
  CollectionReference _collection =
      FirebaseFirestore.instance.collection('reward_options');

  // Constructor
  RewardSubOptionService({required this.documentId}) {
    _collection = _collection.doc(documentId).collection('sub_options');
  }

  // Fungsi untuk mengambil semua data dari collection reward_sub_options
  Future<RewardSubOptions> getAll() async {
    try {
      dynamic snapshot = await _collection.get();
      return RewardSubOptions.fromJson(snapshot.docs.map((doc) {
        return RewardSubOption.fromJson({
          'id': doc.id,
          ...doc.data(),
        });
      }).toList());
    } catch (e) {
      rethrow;
    }
  }

  // Fungsi untuk mengambil data dari collection reward_sub_options berdasarkan id
  Future<RewardSubOption> get(String id) async {
    try {
      final DocumentSnapshot snapshot = await _collection.doc(id).get();
      return RewardSubOption.fromJson(snapshot.data() as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }
}
