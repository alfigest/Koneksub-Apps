//Melakukan import paket cloud_firestore
import 'package:cloud_firestore/cloud_firestore.dart';

//Class List untuk menyimpan mitra-mitra
class PartnerShips {
  //Deklarasi List untuk data-data mitra
  List<PartnerShip>? partnerShips;

  //Fungsi untuk mengubah dari JSON ke class
  PartnerShips.fromJson(List<dynamic> data) {
    partnerShips = <PartnerShip>[];
    for (var v in data) {
      partnerShips!.add(v);
    }
  }

  //Fungsi untuk mengubah dari class ke JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (partnerShips != null) {
      data[''] = partnerShips!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

//Class untuk menyimpan data-data sebuah mitra
class PartnerShip {
  final String? id;
  final GeoPoint? coord;
  final String? address;
  final String? name;
  final String? email;
  final String? whatsapp;
  final String? status;
  final String? image;
  final List? trash;

  //Constructor
  PartnerShip({
    this.id,
    this.coord,
    this.address,
    this.name,
    this.email,
    this.whatsapp,
    this.status,
    this.image,
    this.trash,
  });

// Fungsi mengubah dari JSON ke class
  factory PartnerShip.fromJson(Map<String, dynamic> json) => PartnerShip(
        id: json['id'],
        coord: json["coord"],
        address: json["drop_point"],
        name: json["nama_mitra"],
        email: json["email_mitra"],
        whatsapp: json["whatsapp"],
        status: json["status"],
        image: json["image"],
        trash: json["trash"],
      );

  //Fungsi mengubah dari class ke JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        "coord": coord,
        "drop_point": address,
        "nama_mitra": name,
        "email_mitra": email,
        "whatsapp": whatsapp,
        "status": status,
        "image": image,
        "trash": trash,
      };
}
