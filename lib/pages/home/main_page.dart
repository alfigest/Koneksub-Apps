import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waste_application/pages/history_page.dart';
import 'package:waste_application/pages/home/home_page.dart';
import 'package:waste_application/pages/qrcode_page.dart';
import 'package:waste_application/theme.dart';

import '../../services_and_dataclass/username_login.dart';

class MainPage extends StatefulWidget {
  final String Main_EmailUser;

  const MainPage({Key? key, required this.Main_EmailUser}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // var getUsername = ModalRoute.of(context)!.settings.arguments as LoginInfo;
    // var EmailSend = getUsername.email.toString();

    Widget _scanButton() {
      return FloatingActionButton(
        onPressed: () {
          //Navigator.pushNamed(context, '/qrcode');
          Navigator.push(context, MaterialPageRoute(builder: (context)=> QrCodePage(username: widget.Main_EmailUser)));
        },
        child: Image.asset(
          'assets/qr_icon.png',
          width: 40,
          height: 40,
        ),
        backgroundColor: primaryColor,
      );
    }

    Widget _customButtonNavbar() {
      return ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
        child: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 10,
          clipBehavior: Clip.antiAlias,
          child: BottomNavigationBar(
            backgroundColor: bgColor8,
            currentIndex: currentIndex,
            onTap: (value) {
              print(value);
              setState(() {
                currentIndex = value;
              });
            },
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(
                    top: 10,
                    bottom: 5,
                  ),
                  child: Image.asset(
                    'assets/icon_home.png',
                    width: 23,
                    color: currentIndex == 0 ? primaryColor : Color(0xff808191),
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icon_history.png',
                  width: 35,
                  color: currentIndex == 1 ? primaryColor : Color(0xff808191),
                ),
                label: '',
              ),
            ],
          ),
        ),
      );
    }

    Widget _body() {
      switch (currentIndex) {
        case 0:
          return HomePage(
            Home_getEmailUser: widget.Main_EmailUser,
          );
          break;
        case 1:
          return OrderHistory(
              BolehBack: false,
              userProfileName: widget
                  .Main_EmailUser); //dari home ndak bisa back biar ndak ke OTP lagi
        //break;

        default:
          return HomePage(
            Home_getEmailUser: widget.Main_EmailUser,
          );
      }
    }

    return Scaffold(
      backgroundColor: bgColor8,
      floatingActionButton: _scanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _customButtonNavbar(),
      body: _body(),
    );
  }
}
