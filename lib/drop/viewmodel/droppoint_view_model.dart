import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waste_application/data/response/api_response.dart';

//Import model drop point
import '../model/droppoint_model.dart';

//Import servis drop point
import '../model/service/droppoint_service.dart';

class PartnerShipViewViewModel with ChangeNotifier {
  final _partnerShipService = PartnerShipService();
  final _auth = FirebaseAuth.instance;

  ApiResponse<PartnerShips> partnerShips =
      ApiResponse<PartnerShips>.loading('Loading');

  setPartnerShipList(ApiResponse<PartnerShips> value) {
    partnerShips = value;
    notifyListeners();
  }

  Future<void> fecthPartnerShipsApi() async {
    await _partnerShipService.getall().then((value) {
      setPartnerShipList(ApiResponse<PartnerShips>.completed(value));
    }).catchError((e) {
      setPartnerShipList(ApiResponse<PartnerShips>.error(e.toString()));
    });
  }
}
