class Mitra {
  final String? coord;
  final String? drop;
  final String? email;
  final String? id;
  final String? nama_mitra;
  final String? status;
  final String? whatsapp;

  Mitra(
      {this.coord,
      this.drop,
      this.email,
      this.id,
      this.nama_mitra,
      this.status,
      this.whatsapp});

  factory Mitra.fromJson(Map<String, dynamic> json) => Mitra(
      coord: json["judul"],
      drop: json["konten"],
      email: json["waktu"],
      id: json["id"],
      nama_mitra: json["nama_mitra"],
      status: json["status"],
      whatsapp: json["whatsapp"]);

  Map<String, dynamic> toJson() => {
        "coord": coord,
        "drop": drop,
        "email": email,
        "id": id,
        "nama_mitra": nama_mitra,
        "status": status,
        "whatsapp": whatsapp
      };
}

//data untuk history drop sampah
class DataDropSampah {
  final String? id_mitra;
  final String? id_upload;
  final String? time_stamp;
  final String? uid_user;

  DataDropSampah(
      {this.id_mitra, this.id_upload, this.time_stamp, this.uid_user});

  factory DataDropSampah.fromJson(Map<String, dynamic> json) => DataDropSampah(
      id_mitra: json["id_mitra"],
      id_upload: json["id_upload"],
      time_stamp: json["time_stamp"],
      uid_user: json["uid_user"]);

  Map<String, dynamic> toJson() => {
        "id_mitra": id_mitra,
        "id_upload": id_upload,
        "time_stamp": time_stamp,
        "uid_user": uid_user
      };
}
