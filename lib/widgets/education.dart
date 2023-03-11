import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waste_application/theme.dart';
import 'package:intl/intl.dart';

//dokumentasi : Widget education untuk menampilkan bentuk bentuk dari education
Widget education(Function()? onTap, DocumentSnapshot? getDataFirebase) {
  Timestamp waktu = getDataFirebase!['waktu_artikel'] as Timestamp;
  DateTime d = waktu.toDate();
  String formattedDate =DateFormat('EEEE').format(d) + "," +DateFormat('dd-MM-yyyy  | kk:mm').format(d);
  return GestureDetector(
    onTap: onTap, //{
    //Navigator.pushNamed(context, '/education');
    //},
    child: Container(
      margin: EdgeInsets.only(
        left: defaultMargin,
        right: defaultMargin,
        bottom: defaultMargin,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            // child: Image.asset(
            //   //'assets/education.png',
            //   width: 120,
            //   height: 120,
            //   fit: BoxFit.cover,
            // ),
            child: Stack(
              children: [
                Image.network(
                  getDataFirebase![
                      'image_link'], //mengambil field image_link dari firebase yang di show menggunakan image network
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  right: 3,
                  child: Container(
                    color: Colors.green,
                    //decoration: BoxDecoration(image: ),

                    child: Row(
                      children: [
                        Text(
                          "Education",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                )
              ],
              // child:
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               
                Text(
                  //'Judul Berita Education',
                  getDataFirebase['judul'],
                  style: text_barStyle.copyWith(
                    fontSize: 18,
                    fontWeight: semiBold,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ), Text(formattedDate),
                
                // Text(
                //   //'9-8-2022',
                //   'Click to view',
                //   style: secondaryTextStyle.copyWith(
                //     fontSize: 12,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
