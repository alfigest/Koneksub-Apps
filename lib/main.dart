import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waste_application/drop/droppointui.dart';
import 'package:waste_application/pages/edit_profile.dart';
import 'package:waste_application/pages/history_page.dart';
import 'package:waste_application/pages/redeem_page.dart';
import 'package:waste_application/pages/home/main_page.dart';
import 'package:waste_application/pages/profile_page.dart';
import 'package:waste_application/pages/qrcode_page.dart';
import 'package:waste_application/pages/redeem_success_page.dart';
import 'package:waste_application/pages/sheet_education.dart';
import 'package:waste_application/pages/sign_in_page.dart';
import 'package:waste_application/pages/sign_up_page.dart';
import 'package:waste_application/pages/splash_page.dart';
import 'pages/otp/otp_verification.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

String getCurrentDatess(String tipe) {
  //rc
  var now = new DateTime.now();
  var day = new DateFormat('d').format(now);
  var month = new DateFormat('M').format(now);
  var year = new DateFormat('y').format(now);
  var hour = new DateFormat('kk').format(now);
  var minute = new DateFormat('mm').format(now);

  switch (month) {
    case "1":
      {
        month = "Januari";
      }
      break;
    case "2":
      {
        month = "Februari";
      }
      break;
    case "3":
      {
        month = "Maret";
      }
      break;
    case "4":
      {
        month = "April";
      }
      break;
    case "5":
      {
        month = "Mei";
      }
      break;
    case "6":
      {
        month = "Juni";
      }
      break;
    case "7":
      {
        month = "Juli";
      }
      break;
    case "8":
      {
        month = "Agustus";
      }
      break;
    case "9":
      {
        month = "September";
      }
      break;
    case "10":
      {
        month = "Oktober";
      }
      break;
    case "11":
      {
        month = "November";
      }
      break;
    case "12":
      {
        month = "Desember";
      }
      break;
    default:
      {
        month = "Invalid Month";
      }
      break;
  }
  String jam = (int.parse(hour) - 24).toString();
  String nowDate = day + " " + month + " " + year;
  if (tipe == "hari") {
    return nowDate;
  } else if (tipe == "jam_menit") {
    return "${hour} : ${minute}";
  }
  return "null";
}

//Shared Preferences Code untuk Login LogOut
Future<String> cekUser() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("UserLog") ?? "";
}

Future<String> cekIDFirebase() async {
  final sp = await SharedPreferences.getInstance();
  return sp.getString("idFirebase") ?? "";
}

void userMasuk(String name, String idFirebase) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(
      "UserLo"
      "g",
      name);
  prefs.setString("idFirebase", idFirebase);
}

void removeSaved() async {
  final rem = await SharedPreferences.getInstance();
  await rem.clear();
}
//Shared Preferences Code untuk Login Logout

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //biar status bar jadi transparant ndak ganggu user
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(MyApp());
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

void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 14.0);
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => ResponsiveWrapper.builder(child,
          maxWidth: 1200,
          minWidth: 480,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.resize(480, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.resize(1000, name: DESKTOP),
          ],
          background: Container(color: Color(0xFFF5F5F5))),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => SplashPage(),
        '/sign-in': (context) => SignInPage(),
        '/sign-up': (context) => SignUpPage(),
        '/home': (context) => MainPage(
              Main_EmailUser: '',
            ),
        '/education': (context) => EducationPage(),
        '/qrcode': (context) => QrCodePage(
              username: "default",
            ),
        //'/qrcode_data' : (context) => MitraDetailPage(QRCodeResult: "mt",),
        '/order-history': (context) => OrderHistory(
              BolehBack: false,
              userProfileName: "",
            ),
        '/RedeemPoint': (context) => RedeemPoint(),
        '/redeem-success': (context) => RedeemSuccess(),
        '/profile': (context) => ProfilePage(),
        '/otp-verif': (context) => OTPVerification(
              username: 'default',
              no_telphone: 'default',
            ),
        '/edit-profile': (context) => EditProfilePage(
              email: "testing@gmail.com",
            ),
        '/droppoint': (context) => DropPointPage(),
      },
    );
  }
}
