import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:shimmer/shimmer.dart';

import 'package:waste_application/model/carousel_model_sheetbar.dart';
import 'package:waste_application/pages/edit_profile.dart';
import 'package:waste_application/pages/sheet_education.dart';
import 'package:waste_application/pages/view_article.dart';
import 'package:waste_application/services_and_dataclass/sv_user_sgup.dart';
import 'package:waste_application/services_and_dataclass/username_login.dart';
import 'package:waste_application/theme.dart';
import 'package:waste_application/widgets/customtext_education.dart';
import 'package:waste_application/widgets/education.dart';
import 'package:waste_application/widgets/tutorial.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:io' show Platform;

class HomePage extends StatefulWidget {
  final String Home_getEmailUser;

  const HomePage({Key? key, required this.Home_getEmailUser}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String url = "";
  int countUp = 0;
  Timer? timer;
  late Timer _timer;
  var userPoint = -5;
  String kirim_email = "";

  //dokumentasi : Function untuk mendapatkan jumlah point dari User, pertamanya di setting -5, kalo belum get data dari firestore
  Future<void> getPoint() async {
    // Future.delayed(Duration(milliseconds: 10000), () async {
    print("kirim Emaill : " + kirim_email);
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final email = user!.email;
    final DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
        .instance
        .collection('UserDetail')
        .doc(widget.Home_getEmailUser)
        .get();
    final int tempPoint = doc.data()!['point'];
    setState(() {
      userPoint = tempPoint;
      //userPoint = 0;
    });
    // });
  }

  //dokumentasi : Function untuk save data user Auth ke sharedpreferences
  Future<void> savetoSP(
      String LoggedInUsername, String LoggedInFirebaseID) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString("LoggedUsername", LoggedInUsername);
    print("ter save");
    sp.setString("LoggedInFirebaseID", LoggedInFirebaseID);
  }

  //dokumentasi : Function untuk mengambil profile picture dari user, diambil dari uid user, yang merupakan auth.currentUser dari user
  Future<dynamic> getPfp() async {
    final FirebaseStorage _storage = FirebaseStorage.instanceFor(
        bucket: "gs://wastemanagement-65034.appspot.com");
    var defaultStorageRef =
        _storage.ref().child("users/images/blank_profile.png");
    url = await defaultStorageRef.getDownloadURL();

    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final uid = user!.uid;
    var getProfileRef = _storage.ref().child("users/images/$uid.png");

    await getProfileRef.getDownloadURL().then((value) {
      if (value.isNotEmpty) {
        setState(() {
          url = value;
        });
      }
    }).catchError((e) {});
    return url;
  }

  @override
  void initState() {
    // if (userPoint == -5){
    //   print('getting user point');
    //    timer = Timer.periodic(Duration(seconds : 1),(_) => getPoint());
    // }
    getPoint();
    getPfp();
    savetoSP(
        getEmailUsername(widget.Home_getEmailUser.toString()),
        FirebaseAuth.instance.currentUser?.uid ??
            "NO_ID"); //dokumentasi : Untuk mengesave Email User, dan FirebaseAuth UID
    //getPoint();
    super.initState();
  }

  String testing = "x";
  int _current = 0;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];

    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  //dokumentasi : Function untuk mengambil string userName, dari email
  String getEmailUsername(String email_name) {
    int i = 0;
    while (i < email_name.length) {
      if (email_name[i] == "@") {
        return email_name.substring(0, i);
      }
      i++;
    }
    return "get_username_from_email";
  }

  int balanceBalance = 0;

  @override
  Widget build(BuildContext context) {
    // var getUsername = ModalRoute.of(context)!.settings.arguments as LoginInfo;
    // var LoggedUsername = getEmailUsername(getUsername.email.toString());
    // var EmailSend = getEmailUsername(getUsername.email.toString());
    // var EmailUser = getUsername.email.toString();
    // savetoSP(getUsername.toString(),
    //     FirebaseAuth.instance.currentUser?.uid ?? "NO_ID");
    // setState(() {
    //   kirim_email = EmailUser;
    // });
    Widget _head() {
      return Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 340,
                decoration: BoxDecoration(
                  color: Color(0xff368983),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 35,
                      left: 400,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Container(
                          height: 100,
                          width: 100,
                          color: Color(0xff368983),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40, left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'KonekSub',
                            style: button_TextStyle.copyWith(
                                fontSize: 24, fontWeight: semiBold),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            'Hai, ' +
                                getEmailUsername(widget.Home_getEmailUser),
                            style: sub_nameuser_TextSyle.copyWith(
                              fontSize: 16,
                              fontWeight: semiBold,
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

          //boxheader
          Positioned(
            top: 140,
            left: 70,
            child: Container(
              height: 175,
              width: 320,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(47, 125, 121, 0.3),
                    offset: Offset(0, 6),
                    blurRadius: 12,
                    spreadRadius: 6,
                  ),
                ],
                color: Color.fromARGB(255, 47, 125, 121),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Poinmu',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.more_horiz,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 7),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        userPoint == -5
                            ? Shimmer.fromColors(
                                baseColor: Colors.white,
                                highlightColor: primaryColor,
                                child: Text(
                                  'Memuat Poinmu',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ))
                            : Text(
                                userPoint.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/RedeemPoint',
                                    arguments: widget.Home_getEmailUser);
                              },
                              child: Image.asset(
                                'assets/icon_redem.png',
                                width: 90,
                                height: 90,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/droppoint');
                              },
                              child: Image.asset(
                                'assets/icon_drop.png',
                                width: 90,
                                height: 90,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            //dokumentasi : Untuk push ke profile, kalo ada userProfile akan ke show gambar dari user tersebut kalo nggak ada akan ada gambar profile orang biasa default
                            GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/profile',
                                      arguments: LoginInfo(
                                          widget.Home_getEmailUser.toString()));
                                },
                                child: url == ""
                                    ? Image(
                                        image: AssetImage(
                                          'assets/icon_profil.png',
                                        ),
                                        width: 90,
                                        height: 90,
                                      )
                                    : CircleAvatar(
                                        radius: 20.0,
                                        backgroundImage: NetworkImage(
                                          url,
                                        ),
                                      )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      );
    }

    Widget Barsheet() {
      return Container(
        margin: EdgeInsets.only(
          left: defaultMargin,
          right: defaultMargin,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 180,
              child: Swiper(
                onIndexChanged: (index) {
                  setState(() {
                    _current = index;
                  });
                },
                autoplay: false,
                layout: SwiperLayout.DEFAULT,
                itemCount: carousels.length,
                itemBuilder: (BuildContext context, index) {
                  return Container(
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          carousels[index]!.image.toString(),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                    children: map(carousels, (index, image) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    height: 8,
                    width: 8,
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == index
                            ? primaryColor
                            : subtitleTextColor),
                  );
                })),
              ],
            )
          ],
        ),
      );
    }

    Widget EducationTitle() {
      return Container(
        margin: EdgeInsets.only(
          top: defaultMargin,
          left: defaultMargin,
          right: defaultMargin,
        ),
        child: Customtext_education(
            iconPath: "assets/logo_koneksub.png",
            iconText: "Berita Edukasi",
            subtitle: "Edukasi daur ulang sampah Surabaya",
            caption: ""),
      );
    }

    //dokumentasi : Widget untuk mengambil artikel artikel yang ada di firestore
    Widget Eduction_sheet() {
      return Container(
        margin: const EdgeInsets.only(),
        // child: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("artikel")
                .snapshots(), //dokumentasi : letak table artikel di firestore
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child:
                        CircularProgressIndicator()); //dokumentasi : Ketika masih mengambil data, return loadingprocessindicator
              }
              if (snapshot.hasData) {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: ((context, index) {
                    DocumentSnapshot data = snapshot.data!.docs[index];
                    return education((() {
                      //dokumentasi : disini data yang diambil dari firestore, dibuat dalam bentuk dari widget education bisa dilihat di widgets/education
                      Navigator.push(
                        //dokumentasi : function onclicknya push ke remakesheeteducation
                        context,
                        MaterialPageRoute(
                          builder: (context) => RemakeSheetEducation(
                            id: data.id,
                            penulis: data['penulis'],
                            textJudul: data['judul'],
                            textKeterangan: data['konten'],
                          ),
                        ),
                      );
                    }), data);
                  }),
                );
              }
              return const Center(child: CircularProgressIndicator());
            }),
        // ),
      );
    }

    showAlertDialog(BuildContext context) {
      // set up the buttons
      Widget cancelButton = TextButton(
        child: Text(
          "Cancel",
          style: TextStyle(color: Colors.black),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      Widget continueButton = TextButton(
        child: Text(
          "Continue",
          style: TextStyle(color: Colors.red),
        ),
        onPressed: () {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else {
            exit(0);
          }
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: ElevatedButton.icon(
            onPressed: () {}, icon: Icon(Icons.dangerous), label: Text("Exit")),
        content: Text("Are you sure want to exit this application?"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    //cooler alert dialog confirmation

    //dokumentasi : Disini ada alert ketika user ingin back apps dari home page agar tidak langsung keluar
    return WillPopScope(
        onWillPop: () async {
          //https://stackoverflow.com/questions/45109557/flutter-how-to-programmatically-exit-the-app
          //recommended android pake SystemNavigator.pop(), kalo ios exit(0)
          Alert(
            context: context,
            type: AlertType.warning,
            title: "Confirmation",
            desc: "Are you sure want to exit this app?",
            buttons: [
              DialogButton(
                child: Text(
                  "No",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(116, 116, 191, 1.0),
                  Color.fromRGBO(52, 138, 199, 1.0)
                ]),
              ),
              DialogButton(
                child: Text(
                  "Yes",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else {
                    exit(0);
                  }
                },
                color: Color.fromRGBO(0, 179, 134, 1.0),
              )
            ],
          ).show();
          return true;
          //return true;
        },
        child: Scaffold(
            //     body: Stack(children: [
            //   SingleChildScrollView(
            //     child: Expanded(
            //       child: Column(
            //         children: [
            //           _head(),
            //           Barsheet(),
            //           EducationTitle(),
            //           Eduction_sheet(),
            //         ],
            //       ),
            //     ),
            //   ),
            // ]
            body: ListView(
          children: [
            Column(
              children: [
                _head(),
                Barsheet(),
                EducationTitle(),
                Eduction_sheet(),
              ],
            ),
          ],
        )));
  }
}
