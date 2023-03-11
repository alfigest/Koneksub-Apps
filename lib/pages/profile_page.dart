import 'dart:io';

import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waste_application/main.dart';
import 'package:waste_application/pages/edit_profile.dart';
import 'package:waste_application/pages/history_page.dart';
import 'package:waste_application/pages/sign_in_page.dart';
import 'package:waste_application/services_and_dataclass/username_login.dart';
import 'package:waste_application/theme.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

String getEmailUsername(String email_name) {
  //untuk ngambil username dari email
  int i = 0;
  while (i < email_name.length) {
    if (email_name[i] == "@") {
      return email_name.substring(0, i);
    }
    i++;
  }
  return "get_username_from_email";
}

class _ProfilePageState extends State<ProfilePage> {
  String url = "";

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }

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
    getPfp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var ProfileUsername =
        ModalRoute.of(context)!.settings.arguments as LoginInfo;

    var LoggedUsername = getEmailUsername(ProfileUsername.email.toString());
    var EmailSend = ProfileUsername.email.toString();
    var Header_selamat = "";
    Widget _header() {
      return AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.all(defaultMargin),
            child: Row(
              children: [
                ClipOval(
                    child: url == ""
                        ? Image(
                            image: AssetImage(
                              'assets/admin.png',
                            ),
                            width: 64,
                            height: 64,
                          )
                        : Image.network(
                            url,
                            width: 64,
                            height: 64,
                          )),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hai, ${getEmailUsername(ProfileUsername.email)}',
                        style: button_TextStyle.copyWith(
                            fontSize: 24, fontWeight: bold),
                      ),
                      Text(
                        "@alex",
                        style: subtitleTextStyle.copyWith(
                            fontSize: 16, fontWeight: regular),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      logOut();
                      removeSaved();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/sign-in', (Route<dynamic> route) => false);
                    },
                    child: Image.asset('assets/button_exit.png', width: 26)),
              ],
            ),
          ),
        ),
      );
    }

    Widget _menuItem(String text) {
      return Container(
        margin: EdgeInsets.only(top: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: secondaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: regular,
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 16,
              color: text_bar,
            ),
          ],
        ),
      );
    }

    Widget _content() {
      return Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          width: double.infinity,
          decoration: BoxDecoration(color: bgColor8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Text(
                'Account',
                style: text_barStyle.copyWith(
                  fontSize: 18,
                  fontWeight: semiBold,
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  // Navigator.of(context).pushNamed('/edit-profile', arguments: LoginInfo(ProfileUsername.email));

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditProfilePage(email: EmailSend)));
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Image.asset("assets/edit_profile.png"),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Edit Profile",
                      style: blackTextFont.copyWith(fontSize: 16),
                    )
                  ],
                ),

                // child: _menuItem('Edit Profile'),
              ),
              Container(
                  margin: EdgeInsets.only(top: 10, bottom: 16),
                  child: FDottedLine(
                    color: Color(0xFFE4E4E4),
                    width: 312.0,
                  )),
              GestureDetector(
                onTap: () {
                  //Navigator.of(context).pushNamed('/order-history', arguments: LoginInfo("")); //null parameter
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrderHistory(
                              BolehBack: true,
                              userProfileName: EmailSend.toString(),
                            )),
                  );
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Image.asset("assets/my_wallet.png"),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "History",
                      style: blackTextFont.copyWith(fontSize: 16),
                    )
                  ],
                ),

                // child: _menuItem('History'),
              ),
              Container(
                  margin: EdgeInsets.only(top: 10, bottom: 16),
                  child: FDottedLine(
                    color: Color(0xFFE4E4E4),
                    width: 312.0,
                  )),
            ],
          ),
        ),
      );
    }

    return Center(
        child: Column(
      children: [
        _header(),
        _content(),
      ],
    ));
  }
}
