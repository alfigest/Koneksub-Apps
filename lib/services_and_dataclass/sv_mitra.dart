import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waste_application/services_and_dataclass/dc_mitra.dart';

CollectionReference tblMitra = FirebaseFirestore.instance.collection("mitra");
CollectionReference tblHistorySampah =
    FirebaseFirestore.instance.collection("dataSetorSampah");
String namaMitra = "";
String getNameMitra = "";

class DataMitra {
  static String getMitraName(String docID) {
    tblMitra.doc(docID).get().then((DocumentSnapshot DataMitra) {
      namaMitra = DataMitra['nama_mitra'];
    });
    return namaMitra;
  }

  Stream<List<Mitra>> getMitraData() => FirebaseFirestore.instance
      .collection("mitra")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Mitra.fromJson(doc.data())).toList());

  static String getSpecificMitraData(String id) {
    tblMitra.doc().get().then((DocumentSnapshot DataMitra) {
      getNameMitra = tblMitra
          .orderBy("id")
          .startAt([id]).endAt([id + '\uf8ff']).snapshots() as String;
    });
    return getNameMitra;
  }
}

class GetDataSampah {
  static Stream<QuerySnapshot> getHistorybyUID(String status, String uid) {
    return tblHistorySampah
        // .orderBy("uid_user") .orderBy("status")
        // .startAt([uid, status]).endAt([uid + '\uf8ff', [status + '\uf8ff']]).snapshots();
        .orderBy("status")
        .startAt([uid]).endAt([uid + '\uf8ff']).snapshots();
  }
}
