import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:waste_application/services_and_dataclass/dc_article.dart';

class DataArticleService {
  static final CollectionReference _collection =
      FirebaseFirestore.instance.collection('artikel');

  static Future<List<DataArticle>> getAll() async {
    final QuerySnapshot snapshot = await _collection.get();
    return snapshot.docs.map((doc) {
      return DataArticle.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
    // list.forEach((element) {
    //   static final CollectionReference _collectionImage = FirebaseFirestore.instance
    //   .collection('artikel')
    //   .doc('c97a3b92ad483')
    //   .collection('images');
    // });
    // return list;
  }
}
