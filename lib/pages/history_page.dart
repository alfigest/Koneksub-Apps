import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:waste_application/pages/detaildrophistory.dart';
import 'package:waste_application/pages/home/main_page.dart';
import 'package:waste_application/pages/sheet_education.dart';
import 'package:waste_application/services_and_dataclass/username_login.dart';
import 'package:waste_application/theme.dart';
import 'package:waste_application/pages/trash_diagram.dart';

import '../services_and_dataclass/sv_mitra.dart';
import '../widgets/education.dart';

class OrderHistory extends StatefulWidget {
  final bool BolehBack;
  final String userProfileName;
  const OrderHistory(
      {Key? key, required this.BolehBack, required this.userProfileName})
      : super(key: key);
  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  bool canBack = false;
  int getUserPoint = -5;
  late Timer timer;

  @override
  void initState() {
    canBack = widget.BolehBack;
    // TODO: implement initState
    print("Bolehback : " + widget.BolehBack.toString());
    bool isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    print("isEmailVerified : $isEmailVerified");
    super.initState();
  }

  String TambahiString(String catatan) {
    if (catatan.length <= 33) {
      for (int i = catatan.length; i <= 33; i++) {
        catatan += " ";
      }
    }
    return catatan;
  }

  //tab bar history yang diambil dari firebase (disetor, dipilah, dll)
  Widget TabBarAlfi(
      String IDMitra,
      String waktu,
      String hari,
      String jenisSampah,
      String pointDiDapatkan,
      String viewButton,
      String FIRESTORE_ID,
      bool sudahClaimPoint,
      String imageNetwork,
      String catatan) {
    return InkWell(
      onTap: () {},
      child: Container(
          margin: EdgeInsets.only(
            top: defaultMargin,
            left: defaultMargin,
            right: defaultMargin,
          ),
          height: 200,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white60,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  spreadRadius: 0.5,
                  blurRadius: 5,
                  offset: Offset.zero,
                ),
                BoxShadow(
                  color: Color(0xFFBBBBBB),
                  offset: const Offset(0.0, 0.0),
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                ),
              ]),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 12,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Mitra: ${IDMitra}", //Nama Mitra :
                        style: text_barStyle.copyWith(
                          fontSize: 14,
                          fontWeight: semiBold,
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.arrow_circle_right_outlined,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DropSuksesDetail(
                                    gambarFirestoreID: FIRESTORE_ID,
                                    mitra: IDMitra,
                                    hari: hari,
                                    point: pointDiDapatkan,
                                  ),
                                ));
                          })
                    ],
                  ),
                  // SizedBox(
                  //   height: 6,
                  // ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Gambar Foto Mitra
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            Image.network(
                              imageNetwork,
                              width: 110,
                              height: 110,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                        //Gambar Foto Mitra

                        // Padding(
                        //   child: Image.network(
                        //     imageNetwork,
                        //     width: 100,
                        //     height: 100,
                        //     fit: BoxFit.cover,
                        //   ),
                        //   padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        // ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      //Text("\n" + hari + "\n\nJenis Sampah : $jenisSampah" + "\n\n" "Point Result :"),

                      //Deskripsi Hari, Sampah, Point, Catatan (Masih kadang overflow belum di setting, kalo text kebanyakan)

                      Flexible(
                        child: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: "\n" + hari,
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                              text: "\n\nSampah : " + jenisSampah,
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                              text: "\nPoin yang didapat : " + pointDiDapatkan,
                              style: viewButton == "sukses"
                                  ? TextStyle(color: Colors.black)
                                  : TextStyle(color: Color(0xFFBBBBBB))),
                          TextSpan(
                              text: "\nCatatan : " + TambahiString(catatan),
                              style: TextStyle(color: Colors.black))
                        ])),
                      ),
                      //Deskripsi Hari, Sampah, Point, Catatan (Masih kadang overflow belum di setting, kalo text kebanyakan)

                      SizedBox(
                        width: 80,
                      ),
                      Column(
                        children: [
                          Text("\n" + waktu), //ini waktu
                          SizedBox(
                            height: 10,
                          ),
                          //Button Untuk Get User Point
                          Visibility(
                            visible: viewButton == "sukses"
                                ? true
                                : false, //kalo merupakan sukses di tab viewnya buttonnya ditunjukin ke user

                            child: Visibility(
                              visible: sudahClaimPoint == true ? false : true,
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (sudahClaimPoint == false) {
                                      FirebaseFirestore.instance
                                          .collection("UserDetail")
                                          .doc(
                                              widget.userProfileName.toString())
                                          .update({
                                        "point": FieldValue.increment(
                                            int.parse(pointDiDapatkan))
                                      });
                                      //nambahin point user

                                      //set sudahClaimPoint = true, hide data di tab bar view ini
                                      FirebaseFirestore.instance
                                          .collection("dataSetorSampah")
                                          .doc(FIRESTORE_ID)
                                          .update({"sudahClaimPoint": true});
                                      //set sudahClaimPoint = true, hide data di tab bar view ini

                                      //add checker if success update first
                                      ElegantNotification.success(
                                              width: 360,
                                              title: Text("Congratulations"),
                                              description: Text(
                                                  "Selamat poin anda telah masuk"))
                                          .show(context);
                                    }
                                    //nambahin point user
                                    // else{
                                    //   Navigator.push(context, MaterialPageRoute(builder: (context)=> DropSuksesDetail(gambarFirestoreID: FIRESTORE_ID, mitra: IDMitra, hari: hari, point: pointDiDapatkan,), ));
                                    // }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  child: Text(sudahClaimPoint == false
                                      ? "Get Point"
                                      : "Detail")),
                            ),
                          )

                          // //Button Untuk Get User Point
                        ],
                      ),
                    ],
                  ),
                ],
                //  ] Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     Image.network("https://softwaregenuine.id/wp-content/uploads/2020/09/Batasan-Recycle-Bin-Windows-10.jpg", width: 50, height: 50,),
                //     Text("Drop Point : " + IDMitra +"\n\nWaktu : "+ waktu)
                //   ]),
              ),
            ),
          )),
    );
  }

  Widget ListViewStatusHistory(String UidUser, String status) {
    return Container(
      margin: const EdgeInsets.only(
        top: 14,
      ),
      // child: SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
          stream:
              //GetDataSampah.getHistorybyUID(statusOption,FirebaseAuth.instance!.currentUser!.uid!),
              FirebaseFirestore.instance
                  .collection("dataSetorSampah")
                  // .orderBy("uid_user")
                  // .startAt([statusOption]).endAt([statusOption + '\uf8ff']).snapshots(),
                  .where("uid_user", isEqualTo: UidUser)
                  .where("status", isEqualTo: status)
                  .snapshots(),

          //FirebaseFirestore.instance.collection("artikel").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              //kalo sukses bedanya add Lihat total sampah bulanan,
              if (status == "sukses") {
                return SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //pie_chart(),
                      // GestureDetector(
                      //     onTap: () {
                      //       print("oke buka modal");
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) => pieChart()));
                      //       // showAlertDialog(context);
                      //     },
                      //     child: Padding(
                      //       padding: EdgeInsets.only(top: 200),
                      //       child: Align(
                      //           alignment: Alignment.topRight,
                      //           child: Text(
                      //             "Lihat total sampah bulanan",
                      //             style: TextStyle(
                      //                 color: Colors.red,
                      //                 fontSize: 20.0,
                      //                 decoration: TextDecoration.underline),
                      //             textAlign: TextAlign.end,
                      //           )),
                      //     )),

                      // SizedBox(
                      //   height: 20,
                      // ),
                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: ((context, index) {
                          DocumentSnapshot data = snapshot.data!.docs[index];

                          return TabBarAlfi(
                              data["nama_mitra"],
                              data["time_stamp"],
                              data["day_stamp"],
                              data["jenis_sampah"],
                              data["pointResult"].toString(),
                              "sukses",
                              data.id,
                              data["sudahClaimPoint"],
                              data["imageMitra"],
                              data["catatan"]);
                        }),
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 20,
                          );
                        },
                      ),
                    ],
                  ),
                );
              } else {
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: ((context, index) {
                    DocumentSnapshot data = snapshot.data!.docs[index];
                    return TabBarAlfi(
                        data["nama_mitra"],
                        data["time_stamp"],
                        data["day_stamp"],
                        data["jenis_sampah"],
                        data["pointResult"].toString(),
                        "",
                        data.id,
                        data["sudahClaimPoint"],
                        data["imageMitra"],
                        data["catatan"]);
                  }),
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 20,
                    );
                  },
                );
              }
            }
            return const Center(child: CircularProgressIndicator());
          }),
      // ),
    );
  }

  Future<bool> _willPopCallback() async {
    // Navigator.pushNamed(context, '/home',
    //     arguments: LoginInfo(widget.userProfileName));
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) =>
                MainPage(Main_EmailUser: widget.userProfileName))));

    // await showDialog or Show add banners or whatever
    // then
    return true; // return true if the route to be popped
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //widget.BolehBack == true ? _willPopCallback() : _willPopCallback();
        _willPopCallback();
        return widget.BolehBack;
      },
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          //backgroundColor: Color(0xff030E22),
          backgroundColor: Colors.white60,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            toolbarHeight: 150,
            backgroundColor: Color(0xFFFFFFFF),
            flexibleSpace: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 50.0,
                    left: 10,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (canBack == true) {
                            //Navigator.pop(context);
                            _willPopCallback();
                          }
                        },
                        child: Visibility(
                          visible: canBack == false
                              ? false
                              : true, //kalo dari home push ke history ndak bisa back (karena ada home button di bawah barnya), kalo dari profile bisa
                          child: Image.asset(
                            'assets/box_left.png',
                            width: 40,
                            color: Color(0xff030E22),
                          ),
                        ),
                      ),
                      SizedBox(width: 90),
                      Text(
                        'Order History',
                        style: GoogleFonts.montserrat(
                          color: Color(0xFF00880C),
                          fontSize: 23,
                          fontWeight: semiBold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                TabBar(
                  isScrollable: true,
                  indicatorColor: Color(0xFF00880C),
                  tabs: [
                    Tab(
                      child: Text(
                        'Disetor',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF00880C),
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Diangkut',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF00880C),
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Dipilah',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF00880C),
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Ditimbang',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF00880C),
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Sukses',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF00880C),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ListViewStatusHistory(
                  FirebaseAuth.instance.currentUser!.uid, "disetor"),
              ListViewStatusHistory(
                  FirebaseAuth.instance.currentUser!.uid, "diangkut"),
              ListViewStatusHistory(
                  FirebaseAuth.instance.currentUser!.uid, "dipilah"),
              ListViewStatusHistory(
                  FirebaseAuth.instance.currentUser!.uid, "ditimbang"),
              Scaffold(
                body: ListViewStatusHistory(
                    FirebaseAuth.instance.currentUser!.uid, "sukses"),
                floatingActionButton: FloatingActionButton(
                    child: Icon(
                      Icons.calendar_view_day_sharp,
                    ),
                    backgroundColor: primaryColor,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => pieChart()));
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
