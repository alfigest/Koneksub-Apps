import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waste_application/theme.dart';

class EducationPage extends StatefulWidget {
  const EducationPage({Key? key}) : super(key: key);

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  List images = [
    'assets/education.png',
    'assets/education.png',
    'assets/education.png',
  ];

  int currIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget indicator(int index) {
      return Container(
        width: currIndex == index ? 16 : 8,
        height: 8,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: currIndex == index ? primaryColor : const Color(0xffC4C4C4),
        ),
      );
    }

    Widget header() {
      int index = -1;
      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 20,
              left: defaultMargin,
              right: defaultMargin,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.chevron_left,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          CarouselSlider(
            items: images
                .map(
                  (image) => Image.asset(
                    image,
                    width: MediaQuery.of(context).size.width,
                    height: 310,
                    fit: BoxFit.cover,
                  ),
                )
                .toList(),
            options: CarouselOptions(
                initialPage: 0,
                onPageChanged: (index, reason) {
                  setState(() {
                    currIndex = index;
                  });
                }),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: images.map((e) {
              index++;
              return indicator(index);
            }).toList(),
          ),
        ],
      );
    }

    Widget content() {
      return Container(
        margin: EdgeInsets.all(ArtikelMargin),
        width: double.infinity,
        decoration: BoxDecoration(
          color: bgColor8,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: defaultMargin,
                left: defaultMargin,
                right: defaultMargin,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Olah Sampah Jadi Barang Bernilai Ekonomi Hingga Diekspor ke Sejumlah Negara',
                          style: text_barStyle.copyWith(
                            fontSize: 18,
                            fontWeight: semiBold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Bank Sampah Bersinar Cihampelas, Bandung, Jawa Barat.',
                          style: productCardTextStyle.copyWith(
                            fontSize: 12,
                            fontWeight: regular,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Sariagri - Banyak pihak kini mengolah sampahnya menjadi barang-barang bernilai ekonomi. Barang yang biasanya berakhir di tempat pembuangan akhir sampah, disulap menjadi barang-barang bermanfaat bahkan sampai diekspor ke sejumlah negara.Langkah inilah yang dilakukan oleh Bank Sampah Cihampelas Mandiri (CM) yang berada di RW 05 Kelurahan Cipaganti Kecamatan Coblong Kota Bandung. Di tempat ini sampah yang dihasilkan warga diolah menjadi beragam barang bermanfaatn dan bernilai jual.',
                          style: productCardTextStyle.copyWith(
                            fontSize: 12,
                            fontWeight: regular,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Langkah inilah yang dilakukan oleh Bank Sampah Cihampelas Mandiri (CM) yang berada di RW 05 Kelurahan Cipaganti Kecamatan Coblong Kota Bandung. Di tempat ini sampah yang dihasilkan warga diolah menjadi beragam barang bermanfaatn dan bernilai jual. Di tempat ini sampah yang dihasilkan warga diolah menjadi beragam barang bermanfaatn dan bernilai jual.',
                          style: productCardTextStyle.copyWith(
                            fontSize: 12,
                            fontWeight: regular,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgColor8,
      body: ListView(
        children: [
          header(),
          content(),
        ],
      ),
    );
  }
}

class RemakeSheetEducation extends StatefulWidget {
  final String textJudul;
  final String textKeterangan;
  final String id;
  final String penulis;

  const RemakeSheetEducation(
      {Key? key,
      required this.id,
      required this.penulis,
      required this.textJudul,
      required this.textKeterangan})
      : super(key: key);

  @override
  State<RemakeSheetEducation> createState() => _RemakeSheetEducationState();
}

class _RemakeSheetEducationState extends State<RemakeSheetEducation> {
  List images = [
    "https://firebasestorage.googleapis.com/v0/b/wastemanagement-65034.appspot.com/o/Loading_icon.gif?alt=media&token=67e0297a-5a4c-42b4-a49e-0e2bc1ffe897",
    "https://firebasestorage.googleapis.com/v0/b/wastemanagement-65034.appspot.com/o/Loading_icon.gif?alt=media&token=67e0297a-5a4c-42b4-a49e-0e2bc1ffe897",
    "https://firebasestorage.googleapis.com/v0/b/wastemanagement-65034.appspot.com/o/Loading_icon.gif?alt=media&token=67e0297a-5a4c-42b4-a49e-0e2bc1ffe897"
  ];

  @override
  void initState() {
    super.initState();
    loadImages(widget.id);
  }

  int currIndex = 0;

  Widget build(BuildContext context) {
    String formatTextKeterangan = widget.textKeterangan.replaceAll("\\n", "\n");
    //try using same image network
    Widget indicator(int index) {
      return Container(
        width: currIndex == index ? 16 : 8,
        height: 8,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: currIndex == index ? primaryColor : const Color(0xffC4C4C4),
        ),
      );
    }

    Widget header() {
      //int index = -1;
      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 20,
              left: defaultMargin,
              right: defaultMargin,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.chevron_left,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          CarouselSlider(
            items: images
                .map(
                  (image) => Image.network(
                    image,
                    width: MediaQuery.of(context).size.width,
                    height: 310,
                    fit: BoxFit.cover,
                  ),
                )
                .toList(),
            options: CarouselOptions(
                initialPage: 0,
                onPageChanged: (index, reason) {
                  setState(() {
                    currIndex = index;
                  });
                }),
          ),
          const SizedBox(height: 20),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: widget.images.map((e) {
          //     index++;
          //     return indicator(index);
          //   }).toList(),
          // ),
        ],
      );
    }

    Widget content() {
      return Container(
        margin: EdgeInsets.all(ArtikelMargin),
        width: double.infinity,
        decoration: BoxDecoration(
          color: bgColor8,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: defaultMargin,
                left: defaultMargin,
                right: defaultMargin,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          //'Olah Sampah Jadi Barang Bernilai Ekonomi Hingga Diekspor ke Sejumlah Negara',
                          widget.textJudul,
                          style: text_barStyle.copyWith(
                            fontSize: 20,
                            fontWeight: semiBold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          // 'Bank Sampah Bersinar Cihampelas, Bandung, Jawa Barat.',
                          formatTextKeterangan,
                          style: productCardTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: regular,
                          ),
                        ),
                        // SizedBox(height: 10),
                        // Text(
                        //   'Sariagri - Banyak pihak kini mengolah sampahnya menjadi barang-barang bernilai ekonomi. Barang yang biasanya berakhir di tempat pembuangan akhir sampah, disulap menjadi barang-barang bermanfaat bahkan sampai diekspor ke sejumlah negara.Langkah inilah yang dilakukan oleh Bank Sampah Cihampelas Mandiri (CM) yang berada di RW 05 Kelurahan Cipaganti Kecamatan Coblong Kota Bandung. Di tempat ini sampah yang dihasilkan warga diolah menjadi beragam barang bermanfaatn dan bernilai jual.',
                        //   style: productCardTextStyle.copyWith(
                        //     fontSize: 12,
                        //     fontWeight: regular,
                        //   ),
                        // ),
                        // SizedBox(height: 10),
                        // Text(
                        //   'Langkah inilah yang dilakukan oleh Bank Sampah Cihampelas Mandiri (CM) yang berada di RW 05 Kelurahan Cipaganti Kecamatan Coblong Kota Bandung. Di tempat ini sampah yang dihasilkan warga diolah menjadi beragam barang bermanfaatn dan bernilai jual. Di tempat ini sampah yang dihasilkan warga diolah menjadi beragam barang bermanfaatn dan bernilai jual.',
                        //   style: productCardTextStyle.copyWith(
                        //     fontSize: 12,
                        //     fontWeight: regular,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgColor8,
      body: ListView(
        children: [
          header(),
          content(),
        ],
      ),
    );
  }

  void loadImages(String id) async {
    List newImages = await FirebaseFirestore.instance
        .collection("artikel")
        .doc(widget.id)
        .collection("images")
        .get()
        .then((value) => value.docs.map((e) => e.data()["path"]).toList());
    setState(() {
      images = newImages;
    });
  }
}
