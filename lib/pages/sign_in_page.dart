import 'dart:developer';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waste_application/main.dart';
import 'package:waste_application/pages/home/main_page.dart';
import 'package:waste_application/pages/otp/otp_verification.dart';
import 'package:waste_application/pages/sign_up_page.dart';
import 'package:waste_application/pages/verify_user_email.dart';
import 'package:waste_application/services_and_dataclass/username_login.dart';
import 'package:waste_application/theme.dart';
import 'package:waste_application/utils/auth_message.dart';
import 'package:waste_application/services_and_dataclass/sv_user_sgup.dart';

import 'home/home_page.dart';
import 'dart:io' show Platform;

class SignInPage extends StatefulWidget {
  @override
  State<SignInPage> createState() => _SignInPageState();
}

//void main() {
String getmain() {
  String get_hasil = "";
  WidgetsFlutterBinding.ensureInitialized();
  cekUser().then((String hasil) {
    //https://stackoverflow.com/questions/60069369/flutter-how-to-convert-futurestring-to-string
    if (hasil != "") {
      print("datausername " + hasil);
      get_hasil = hasil;
      return get_hasil; //nda bisa kalo langsung return
      //bypass screen langsung ke main page
    }
  });
  // cekIDFirebase().then((String hasil) { //https://stackoverflow.com/questions/60069369/flutter-how-to-convert-futurestring-to-string
  //   if (hasil !=""){
  //     print("firebase id " + hasil);
  //     //bypass screen langsung ke main page
  //   }
  //   else{
  //     print("no data");
  //   }
  // });
  return get_hasil;
}

class _SignInPageState extends State<SignInPage> {
  bool sudahPindah = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _secureText = true;
  String username_dataSP = "null";
  bool isLoading = false;

  //dokumentasi : Ngecek apakah ada user yang logged in, atau tidak di hp, di save di shared preferences (auth.id sama usernamenya)
  void getUsernameDatazz() {
    cekUser().then((String result) {
      setState(() {
        if (result != "") {
          username_dataSP = result;
          print("dapat nama username : ${username_dataSP}");
        } else {
          print("SP : no res");
        }
      });

      if (username_dataSP != "null") {
        //dokumentasi : Ketika kebetulan ada data di SharedPreferences user ndak perlu login lagi, dan langsung kepindah ke MainPage
        //  Navigator.pushNamed(context, '/home',
        //       arguments: LoginInfo(username_dataSP.toString()));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MainPage(Main_EmailUser: username_dataSP.toString())));
      }
    });
  }

  showHide() {
    //dokumentasi : Untuk ngubah mata show/hide password
    setState(() {
      _secureText = !_secureText;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsernameDatazz();
    print("Username :" + username_dataSP);
  }

  @override
  Widget build(BuildContext context) {
    //String username = getmain();
    // print("Username didapatkan : "+ username);
    // if (username!="qweasdzxc"){

    // }

    // getUsernameDatazz();
    // print("datasp : " + username_dataSP);
    // if (username_dataSP !="null"){
    //   Navigator.pushNamed(context, '/home', arguments: LoginInfo(username_dataSP));
    // }
    Widget _header() {
      return Container(
        margin: EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Login',
              style: primaryTextStyle.copyWith(
                fontSize: 24,
                fontWeight: semiBold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Sign In to Continue ',
              style: subtitleTextStyle.copyWith(
                fontSize: 14,
                fontWeight: regular,
              ),
            ),
            SizedBox(height: 100),
          ],
        ),
      );
    }

    Widget _emailForm() {
      return Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Email Address',
                style: text_barStyle.copyWith(
                  fontSize: 16,
                  fontWeight: medium,
                ),
              ),
              SizedBox(height: 12),
              Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: bgColor8,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: text_bar,
                        offset: Offset(0, 1),
                        blurRadius: 4,
                        spreadRadius: 0),
                  ],
                ),
                child: Center(
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/email_icon.png',
                        width: 23,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                            controller: emailController,
                            decoration: InputDecoration.collapsed(
                              hintText: 'Your Email Address',
                              hintStyle: subtitleTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: regular,
                              ),
                            ),
                            validator: (email) =>
                                email != null && !EmailValidator.validate(email)
                                    ? 'Enter a valid email '
                                    : null),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      );
    }

    Widget _password() {
      return Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Password',
                style: text_barStyle.copyWith(
                  fontSize: 16,
                  fontWeight: medium,
                ),
              ),
              SizedBox(height: 12),
              Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: bgColor8,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: text_bar,
                        offset: Offset(0, 1),
                        blurRadius: 4,
                        spreadRadius: 0),
                  ],
                ),
                child: Center(
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/password_icon.png',
                        width: 23,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          //controller: _emailController,
                          controller: passwordController,
                          obscureText: _secureText,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: showHide,
                              icon: _secureText
                                  ? Icon(
                                      Icons.visibility_off,
                                      size: 23,
                                      color: Colors.grey,
                                    ) // icon
                                  : Icon(
                                      Icons.visibility,
                                      size: 23,
                                      color: Colors.grey,
                                    ),
                            ),
                            border: InputBorder.none,
                            hintText: 'Your Password',
                            hintStyle: subtitleTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: regular,
                            ),
                          ),
                          style: text_barStyle.copyWith(
                            fontSize: 14,
                            fontWeight: regular,
                          ),
                          validator: (value) =>
                              value != null && value.length < 6
                                  ? 'Enter minimum 6 character'
                                  : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      );
    }

    //sign in firebase
    //dokumentasi : Function untuk user sign in
    signIn() {
      setState(() {
        isLoading = true;
      });
      DataUser.getUserPhone(emailController.text.toString()).then((phoneVal) {
        try {
          FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: emailController.text.trim(),
                  password: passwordController.text.toString())
              .then((value) {
            //ke OTP
            if (phoneVal != "" &&
                FirebaseAuth.instance.currentUser!.emailVerified) {
              //dokumentasi : kalo nomer telfonnya udah didapetin, dan user sudah verifikasi email, langsung ke OTP
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OTPVerification(
                        username: emailController.text.trim(),
                        no_telphone: phoneVal),
                  ));
            } else if (phoneVal != "" &&
                FirebaseAuth.instance.currentUser!.emailVerified == false) {
              //dokumentasi : kalo belum verifikasi email ke page verifikasi email terlebih dahulu
              //verify OTP dulu baru pindah ke VerifyEmailUser
              if (sudahPindah == false) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VerifyEmailUser(
                              emailUser: emailController.text.trim(),
                              telephoneUser: phoneVal,
                            )));
                sudahPindah = true;
              }
            }
          }).catchError((e) {
            //dokumentasi : Buat ngeshow snack bar, kalo ada error di sign in, Custom Messagenya juga dapat di custom dari e.message firebasenya diganti yang lain
            // AuthMessage.showSnackBar("email atau password anda salah")
            print("----------------------------------------------------");
            print(e);
            print("----------------------------------------------------");
            String errorInfo = e.toString();
            print("error info : " + errorInfo);

            if (errorInfo ==
                "[firebase_auth/unknown] Given String is empty or null") {
              showToast("Password harus diisi!");
            } else if (errorInfo ==
                "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
              showToast("Password anda salah!");
            }
            //showToast("$e");
          });
        } catch (e) {
          //dokumentasi : Buat ngeshow snack bar, kalo ada error di sign in, Custom Messagenya juga dapat di custom dari e.message firebasenya diganti yang lain
          // AuthMessage.showSnackBar("email atau password anda salah");
          // if (e == " [firebase_auth/unknown] Given String is empty or null") {
          //   showToast("Password harus diisi!");
          // } else if (e ==
          //     " [firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
          //   showToast("Password anda salah!");
          // }
          // showToast("$e");
        }
      }).whenComplete(() {
        setState(() {
          isLoading = false;
        });
      });
    }

    Widget _button() {
      return isLoading
          ? Center(
              child: Container(
                  padding: const EdgeInsets.only(top: 60),
                  child: const CircularProgressIndicator()))
          : Container(
              height: 60,
              width: double.infinity,
              margin: EdgeInsets.only(top: 30),
              child: TextButton(
                //onPressed: signInFunc,
                onPressed: () {
                  //var telfon = DataUser.getUserPhone(emailController.text.toString());
                  signIn(); //dokumentasi : Function signIn dari firebase tadi dipanggil disini
                  //Navigator.pushNamed(context, '/home');
                },
                style: TextButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Sign In',
                  style: button_TextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: bold,
                  ),
                ),
              ),
            );
    }

    Widget _footer() {
      return Container(
        margin: EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Dont\'t have an account? ',
              style: subtitleTextStyle.copyWith(
                fontSize: 12,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/sign-up');
              },
              child: Text(
                'Sign Up',
                style: primaryTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: medium,
                ),
              ),
            )
          ],
        ),
      );
    }

    return WillPopScope(
      //dokumentasi : Untuk exit apps, kalo platform android atau ios beda config pake yang lebih bagusnya, nemu di stackoverflow
      onWillPop: () {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        }
        exit(0);
      },
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus =
              FocusScope.of(context); //ngambil focusnya
          if (!currentFocus.hasPrimaryFocus) {
            //kalo focusnya punya primaryfocus(state ngga ada keyboard)
            currentFocus.unfocus(); //buat di state gak ada keyboard
          }
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: AuthMessage.messengerKey,
          home: Scaffold(
            backgroundColor: bgColor8,
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: defaultMargin,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(),
                    _emailForm(),
                    _password(),
                    _button(),
                    Spacer(),
                    _footer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
