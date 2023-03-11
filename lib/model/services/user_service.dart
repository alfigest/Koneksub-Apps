import 'package:waste_application/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailService {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('UserDetail');

  Future<UserDetail> get(String email) async {
    try {
      final DocumentSnapshot snapshot = await _collection.doc(email).get();
      return UserDetail.fromJson(snapshot.data() as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> update(String id, int userPoint) async {
    try {
      DocumentReference doc = _collection.doc(id);
      await doc.set({'point': userPoint}, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }
}
