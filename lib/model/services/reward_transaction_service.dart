// Melakukan import cloud_firestore untuk pengambilan data
import 'package:cloud_firestore/cloud_firestore.dart';

// Melakukan import model Reward Transaction di folder model
import '../reward_transactions.dart';

class RewardTransactionService {
  // Definisi variabel untuk mengambil data dari collection reward_transactions
  static final CollectionReference _collection =
      FirebaseFirestore.instance.collection('reward_transactions');

  // Fungsi untuk mengambil semua data dari collection reward_transactions
  static Future<RewardTransactions> getAll() async {
    try {
      final QuerySnapshot snapshot = await _collection.get();
      return RewardTransactions.fromJson(snapshot.docs.map((doc) {
        return RewardTransaction.fromJson(doc.data() as Map<String, dynamic>);
      }).toList());
    } catch (e) {
      rethrow;
    }
  }

  // Fungsi untuk mengambil data dari collection reward_transactions berdasarkan id
  static Future<RewardTransaction> get(String id) async {
    try {
      final DocumentSnapshot snapshot = await _collection.doc(id).get();
      return RewardTransaction.fromJson(
          snapshot.data() as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Fungsi untuk menambahkan data ke collection reward_transactions
  static Future<void> add(RewardTransaction option) async {
    try {
      DocumentReference doc = _collection.doc(option.id);
      await doc.set(option.toJson());
    } catch (e) {
      rethrow;
    }
  }

  // Fungsi untuk mengubah data di collection reward_transactions
  static Future<void> update(RewardTransaction option) async {
    try {
      DocumentReference doc = _collection.doc(option.id);
      await doc.update(option.toJson());
    } catch (e) {
      rethrow;
    }
  }

  // Fungsi untuk menghapus data di collection reward_transactions
  static Future<void> delete(String id) async {
    try {
      DocumentReference doc = _collection.doc(id);
      await doc.delete();
    } catch (e) {
      rethrow;
    }
  }
}
