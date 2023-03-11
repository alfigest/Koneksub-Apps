class DataArticle {
  final String? judul;
  final String? konten;
  final String? waktu;

  DataArticle({
    this.judul,
    this.konten,
    this.waktu,
  });

  factory DataArticle.fromJson(Map<String, dynamic> json) => DataArticle(
        judul: json["judul"],
        konten: json["konten"],
        waktu: json["waktu"],
      );

  Map<String, dynamic> toJson() => {
        "judul": judul,
        "konten": konten,
        "waktu": waktu,
      };
}
