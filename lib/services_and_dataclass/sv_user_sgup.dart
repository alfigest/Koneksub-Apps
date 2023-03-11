import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waste_application/services_and_dataclass/dc_user_sgup.dart';

CollectionReference tblSgUp =
    FirebaseFirestore.instance.collection("UserDetail");

String telephone = "";
String email = "";
var points = "";
bool isVerified = false;
// add(data.toJSON())

class DataUser {
  static Future<void> addUsersData(
      {required userSignUp data, required String docID}) async {
    await tblSgUp
        .doc(docID)
        .set(data.toJSON())
        .whenComplete(
            () => print("Sukses add Users Data to Firebase Firestore"))
        .catchError((e) => print("Error Input Users Data : " + e));
  }

  static Future<String> getUserPhone(String docID) async {
    telephone =
        await tblSgUp.doc(docID).get().then((DocumentSnapshot DataUser) {
      return DataUser['phone_number'];
    });
    return telephone;
  }

  static String getUserPoint(String docID) {
    tblSgUp.doc(docID).get().then((DocumentSnapshot DataUser) {
      points = DataUser['point'];
    });
    return points.toString();
  }

  static bool isUserPhoneVerified(String docID) {
    tblSgUp.doc(docID).get().then((DocumentSnapshot DataUser) {
      isVerified = DataUser['phone_verified'];
    });
    return isVerified;
  }

  static Future<void> VerifyTelfon(String docID) async {
    tblSgUp
        .doc(docID)
        .update({'phone_verified': true})
        .whenComplete(() => print("Sukses verifikasi notelpon"))
        .catchError((e) => print("Tidak bisa verifikasi nomer telephone"));
  }

  static Future<void> updateUserPhone(String docID, String notelp) async {
    tblSgUp
        .doc(docID)
        .update({'phone_number': notelp})
        .whenComplete(() => print("Sukses update nomer telephone"))
        .catchError((e) => print("Error update nomer telephone"));
  }
}
