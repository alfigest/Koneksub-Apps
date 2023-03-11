//Import paket cloud_firestore
import 'package:cloud_firestore/cloud_firestore.dart';

//Import model drop point
import '../droppoint_model.dart';

class PartnerShipService {
  //Deklarasi variabel untuk mengambil data dari firestore
  static final CollectionReference _collection =
      FirebaseFirestore.instance.collection('mitra');

  //Fungsi untuk mengambil semua data mitra-mitra dari firestore
  Future<PartnerShips> getall() async {
    try {
      dynamic snapshot = await _collection.get();
      return PartnerShips.fromJson(snapshot.docs.map((doc) {
        return PartnerShip.fromJson(doc.data() as Map<String, dynamic>);
      }).toList());
    } catch (e) {
      rethrow;
    }
  }

  //Fungsi untuk mengambil data mitra dari firestore berdasarkan id
  Future<PartnerShip> get(String id) async {
    try {
      final DocumentSnapshot snapshot = await _collection.doc(id).get();
      return PartnerShip.fromJson(snapshot.data() as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  //Fungsi untuk menambah data mitra di firestore
  Future<void> add(PartnerShip option) async {
    try {
      DocumentReference doc = _collection.doc(option.id.toString());
      await doc.set(option.toJson());
    } catch (e) {
      rethrow;
    }
  }

  //Fungsi untuk mengubah data mitra di firestore
  Future<void> update(PartnerShip option) async {
    try {
      DocumentReference doc = _collection.doc(option.id.toString());
      await doc.update(option.toJson());
    } catch (e) {
      rethrow;
    }
  }

  //Fungsi untuk menghapus data mitra di firestore
  Future<void> delete(String id) async {
    try {
      DocumentReference doc = _collection.doc(id);
      await doc.delete();
    } catch (e) {
      rethrow;
    }
  }
}
