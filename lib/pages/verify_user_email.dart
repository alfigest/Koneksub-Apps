import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waste_application/pages/sign_in_page.dart';
import 'package:waste_application/theme.dart';

import '../services_and_dataclass/sv_user_sgup.dart';
import '../services_and_dataclass/username_login.dart';
import 'otp/otp_verification.dart';

class VerifyEmailUser extends StatefulWidget {
  final String emailUser;
  final String telephoneUser;

  const VerifyEmailUser(
      {Key? key, required this.emailUser, required this.telephoneUser})
      : super(key: key);

  @override
  State<VerifyEmailUser> createState() => _VerifyEmailUserState();
}

class _VerifyEmailUserState extends State<VerifyEmailUser> {
  bool cekisUserVerified = false;
  int durationTimer = 60;
  bool canResend = false;
  Timer? timer;

  int countUpTimer = 0;
  late Timer? _timer;
  CountDownController TimerController = CountDownController();

  showAlertDialog(BuildContext context) {
    //dokumentasi : OkButton untuk pindah ke sign in
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.popUntil(context, ModalRoute.withName('/sign-in'));
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Congratulation"),
      content:
          Text("Your email is verified, you may login with your account now"),
      actions: [
        okButton,
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _timer = Timer.periodic(Duration(milliseconds: 5000), (timer) {
      setState(() {
        countUpTimer++;
        print(countUpTimer);
      });
    });

    cekisUserVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!cekisUserVerified) {
      //dokumentasi : mengecek user, kalo user belum verified, dikirimkan email verification
      sendVerificationEmail();

      timer = Timer.periodic(
          Duration(seconds: 3),
          (_) =>
              checkUserStatus()); //dokumentasi : Setiap 3 detik mengecek status user, kalo email verified diarahkan alert yang mana ada button untuk pindah ke sign in
    } else if (cekisUserVerified) {
      //dokumentasi : Kalo userVerified pindah ke OTP
      print("anda terverifikasi pindah ke OTP");
      DataUser.getUserPhone(widget.telephoneUser).then((value) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPVerification(
                  username: widget.emailUser, no_telphone: value),
            ));
      });
    }
  }

  Widget TimerVerification() {
    return CircularCountDownTimer(
        controller: TimerController,
        width: MediaQuery.of(context).size.width / 10,
        height: MediaQuery.of(context).size.height / 10,
        duration: durationTimer,
        isReverse: true,
        fillColor: Colors.purpleAccent[100]!,
        ringColor: Colors.grey[300]!,
        onComplete: () => canResend = true);
  }

  Future checkUserStatus() async {
    //dokumentasi : Function untuk mengecek status emailUserApakahVerified dari AuthFirebase, Ketika userVerified, diberikan dialog untuk pindah ke sign in
    print("checking user status");
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      cekisUserVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (cekisUserVerified) {
      timer?.cancel();
      print("sudah terverifikasi");
      showAlertDialog(context);
      //push ke home
    }
  }

  Future sendVerificationEmail() async {
    //dokumentasi : Function untuk mengirimkan Send Verification Email
    try {
      final user = FirebaseAuth.instance.currentUser!;
      print("user send verification  : " + user.toString());
      await user.sendEmailVerification();

      await Future.delayed(Duration(seconds: 5)); //timer 5 detik
    } catch (e) {
      print("tidak bisa resend");
    }
  }

  @override
  void ResendVerification() {
    sendVerificationEmail();
    canResend = false;
    TimerController.restart();
    sendVerificationEmail();
  }

  Widget build(BuildContext context) {
    if (cekisUserVerified) {
      //  Navigator.pushNamed(context, '/home',
      //       arguments: LoginInfo(widget.emailUser));
      //Navigator.pushNamed(context, '/sign-in');// SignInPage();
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Text("Verify your email",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 250,
                width: 150,
                child: ElevatedButton(
                  onPressed: () {},
                  child: countUpTimer % 2 == 0
                      ? Icon(
                          Icons.mail,
                          size: 100,
                        )
                      : IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            "assets/spam.png",
                          ),
                          iconSize: 100,
                        ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(CircleBorder()),
                    padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                    backgroundColor: MaterialStateProperty.all(
                        primaryColor), // <-- Button color
                    // overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                    //   if (states.contains(MaterialState.pressed)) return Colors.red; // <-- Splash color
                    // }),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(80, 0, 80, 0),
                child: Column(
                  children: [
                    Text(
                      //dokumentasi : Dari Variable countUpTimer, setiap 5 detik bertambah satu, dan kalo ganjil/genap berganti text dan gambar, yang mana mengingatkan user untuk cek spam email
                      countUpTimer % 2 == 0
                          ? "Confirm your email address, by clicking the link we've sent to your email!"
                          : "Don't forget to check your spam email, maybe in some case it goes to spam",
                      style: TextStyle(height: 2.0, fontSize: 18),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    TimerVerification(),
                    Theme(
                      data: ThemeData(
                          elevatedButtonTheme: ElevatedButtonThemeData(
                              style: ElevatedButton.styleFrom(
                                  onPrimary: Colors.white,
                                  primary: primaryColor))),
                      child: ElevatedButton(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          onPressed: () {
                            if (canResend == true) {
                              //dokumentasi : Kalo sudah bisa Resend, dapat melakukan resend verification email
                              ResendVerification();
                            } else {
                              print("tunggu waktu");
                            }
                          },
                          child: Text("Resend Email")),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
