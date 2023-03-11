import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:otp_autofill/otp_autofill.dart';
import 'package:waste_application/main.dart';
import 'package:waste_application/pages/home/home_page.dart';
import 'package:waste_application/pages/home/main_page.dart';
import 'package:waste_application/services_and_dataclass/sv_user_sgup.dart';

import '../../services_and_dataclass/username_login.dart';
import '../../theme.dart';
import 'package:waste_application/utils/auth_message.dart';
//import 'package:sms_autofill/sms_autofill.dart';

class OTPVerification extends StatefulWidget {
  final String username;
  final String no_telphone;

  const OTPVerification(
      {Key? key, required this.username, required this.no_telphone})
      : super(key: key);

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  //late OTPTextEditController controllerOTP5dig;

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

  //listen Code
  // Future<void> getCode() async {
  //   await SmsAutoFill().listenForCode;
  // }

  String? _verificationCode;
  String _code = "";
  TextEditingController InputOTP = TextEditingController();
  TextEditingController OTP_1 = TextEditingController();
  TextEditingController OTP_2 = TextEditingController();
  TextEditingController OTP_3 = TextEditingController();
  TextEditingController OTP_4 = TextEditingController();
  TextEditingController OTP_5 = TextEditingController();
  TextEditingController OTP_6 = TextEditingController();
  bool canResend = false;

  @override
  void initState() {
    // TODO: implement initState
    print("init state succesfully launched");
    _verifyPhone(widget.no_telphone);

    //coba OTP Controller
    //getCode();
  }

  // WidgetAutoFilledOTP() {
  //   return PinFieldAutoFill(
  //       //  decoration: UnderlineDecoration(
  //       //    textStyle: TextStyle(fontSize: 20, color: Colors.black),
  //       //    colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
  //       //  ),
  //       decoration: BoxLooseDecoration(
  //           textStyle: TextStyle(fontSize: 20, color: Colors.black),
  //           strokeColorBuilder:
  //               FixedColorBuilder(Colors.black.withOpacity(0.3))),
  //       currentCode: _code,
  //       // prefill with a code
  //       onCodeSubmitted: (code) {},
  //       //code submitted callback
  //       onCodeChanged: (code) {
  //         if (code!.length == 6) {
  //           FocusScope.of(context).requestFocus(FocusNode());
  //         } //code changed callback
  //       },
  //       codeLength: 6);
  // }

  _verifyPhone(String notelp) {
    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+62 ${notelp.toString()}',
        verificationCompleted: (PhoneAuthCredential credential) {
          //  FirebaseAuth.instance
          //     .signInWithCredential(credential)
          //     .then((value) {
          //   if (value.user != null) {
          //     print("Masuk");
          //   }
          // });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String? verficationID, int? resendToken) {
          setState(() {
            _verificationCode = verficationID;
            print("Kode Verifikasi :" + _verificationCode.toString());
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }

  String _getToken() {
    if (OTP_1.text.isNotEmpty &&
        OTP_2.text.isNotEmpty &&
        OTP_3.text.isNotEmpty &&
        OTP_4.text.isNotEmpty &&
        OTP_5.text.isNotEmpty &&
        OTP_6.text.isNotEmpty) {
      return OTP_1.text.toString() +
          OTP_2.text.toString() +
          OTP_3.text.toString() +
          OTP_4.text.toString() +
          OTP_5.text.toString() +
          OTP_6.text.toString();
    }
    return "ndak_lengkap";
  }

  _verifySMSCode() async {
    bool isUserPhoneVerified = false;
    if (_getToken() != "ndak_lengkap") {
      print(_getToken());

      try {
        await FirebaseAuth.instance
            .signInWithCredential(PhoneAuthProvider.credential(
                verificationId: _verificationCode!, smsCode: _getToken()))
            .then((value) async {
            //force login
          setState(() {
            _verificationCode = "123456";
          });
          //force login
          // if (value.user != null || _verificationCode == "123456") {
            if (_verificationCode == "123456"){
              await DataUser.VerifyTelfon(widget.username);
              print("bisa login");
              userMasuk(widget.username,
                  FirebaseAuth.instance.currentUser?.uid ?? "no_id");
              // Navigator.pushNamed(context, '/home',
              //     arguments: LoginInfo(widget.username));
              // Navigator.pushNamed(context, '/home', arguments: LoginInfo(widget.username));

              //try new method, biar function di widget build ndak kepanggil terus
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => MainPage(
                            Main_EmailUser: widget.username,
                          ))));
          }
        });
      } catch (e) {
        AuthMessageOTP.showSnackBar(e.toString(), 300);
        // AuthMessageOTP.showSnackBar("OTP yang diberikan salah", 650);
      }
    } else {
      AuthMessageOTP.showSnackBar("OTP salah", 650);
    }
  }

  @override
  Widget build(BuildContext context) {
    //buat text field auto filled sementara di disable

    // Widget textFieldSementara() {
    //   return TextField(
    //     controller: InputOTP,
    //     decoration: InputDecoration(labelText: 'Input OTP Sementara'),
    //   );
    // }

    Widget _header() {
      return Container(
        margin: EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'OTP Verification',
              style: primaryTextStyle.copyWith(
                fontSize: 22,
                fontWeight: semiBold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Enter the code sent to +62 ${widget.no_telphone} to continues,  ' +
                  getEmailUsername(widget.username),
              style: subtitleTextStyle.copyWith(
                fontSize: 14,
                fontWeight: regular,
              ),
            ),
            // Text(
            //   'Langsung klik sign in saja bos',
            //   style: subtitleTextStyle.copyWith(
            //     fontSize: 14,
            //     fontWeight: regular,
            //   ),
            // ),
            SizedBox(height: 100),
          ],
        ),
      );
    }

    Widget _textFieldOTP(
        {required bool first,
        last,
        required TextEditingController getValueEachOTP,
        required FocusNode focusSide,
        required FocusNode NodeNow}) {
      return Container(
        height: 85,
        width: 50,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: TextField(
            focusNode: NodeNow,
            controller: getValueEachOTP,
            autofocus: true,
            onChanged: (value) {
              if (value.length == 1 && last == false) {
                FocusScope.of(context).requestFocus(focusSide);
              }
              // if (value.length == 0 && first == false) {
              //   FocusScope.of(context).previousFocus();
              // }
            },
            showCursor: false,
            readOnly: false,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: InputDecoration(
              counter: Offstage(),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.black12),
                  borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.purple),
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      );
    }

    Widget _buttonSubmit() {
      return ElevatedButton(onPressed: () {}, child: Text("Submit Code"));
    }

    Widget _buttonAlfi() {
      return Container(
        height: 60,
        width: double.infinity,
        margin: EdgeInsets.only(top: 50),
        child: TextButton(
          //onPressed: signInFunc,
          onPressed: () {
            FocusScopeNode currentFocus =
                FocusScope.of(context); //ngambil focusnya
            if (!currentFocus.hasPrimaryFocus) {
              //kalo focusnya punya primaryfocus(state ngga ada keyboard)
              currentFocus.unfocus(); //buat di state gak ada keyboard
            }
            _verifySMSCode();
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

    Widget _buttonAlfiLangsungMasuk() {
      return Container(
        height: 60,
        width: double.infinity,
        margin: EdgeInsets.only(top: 50),
        child: TextButton(
          //onPressed: signInFunc,
          onPressed: () {
            FocusScopeNode currentFocus =
                FocusScope.of(context); //ngambil focusnya
            if (!currentFocus.hasPrimaryFocus) {
              //kalo focusnya punya primaryfocus(state ngga ada keyboard)
              currentFocus.unfocus(); //buat di state gak ada keyboard
            }
             Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => MainPage(
                            Main_EmailUser: widget.username,
                          ))));
          },
          style: TextButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Sign In (Auto Masuk (no data res))',
            style: button_TextStyle.copyWith(
              fontSize: 18,
              fontWeight: bold,
            ),
          ),
        ),
      );
    }

    Widget TimerOTP() {
      return CircularCountDownTimer(
          width: MediaQuery.of(context).size.width / 10,
          height: MediaQuery.of(context).size.height / 10,
          duration: 120,
          isReverse: true,
          fillColor: Colors.purpleAccent[100]!,
          ringColor: Colors.grey[300]!,
          onComplete: () => canResend = true);
    }

    Widget resendCode() {
      return Row(
        children: [
          Text(
            "didnt receive the code?",
            style: subtitleTextStyle.copyWith(
              fontSize: 14,
              fontWeight: regular,
            ),
          ),
          GestureDetector(
            onTap: () {
              if (!canResend) {
                AuthMessageOTP.showSnackBar("Wait for the timer",
                    MediaQuery.of(context).size.height / 2);
              } else {
                AuthMessageOTP.showSnackBar(
                    "resend the code, but not executed due to quota", 650);
              }
            },
            child: Text("send again",
                style: subtitleTextStyle.copyWith(
                    fontSize: 14, color: Colors.red)),
          )
        ],
      );
    }

    Widget _buttonCheat() {
      return Container(
        height: 60,
        width: double.infinity,
        margin: EdgeInsets.only(top: 50),
        child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/home',
                arguments: LoginInfo(widget.username));
          },
          style: TextButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Sign In Langsung Masuk',
            style: button_TextStyle.copyWith(
              fontSize: 18,
              fontWeight: bold,
            ),
          ),
        ),
      );
    }

    Widget appBarTop() {
      return AppBar(
        title: Text("OTP Login Confirmation"),
      );
    }

    FocusNode textFirstFocusNode = new FocusNode();
    FocusNode textSecondFocusNode = new FocusNode();
    FocusNode textThirdFocusNode = new FocusNode();
    FocusNode textFourthFocusNode = new FocusNode();
    FocusNode textFifthFocusNode = new FocusNode();
    FocusNode textSixthFocusNode = new FocusNode();

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context); //ngambil focusnya
        if (!currentFocus.hasPrimaryFocus) {
          //kalo focusnya punya primaryfocus(state ngga ada keyboard)
          currentFocus.unfocus(); //buat di state gak ada keyboard
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: AuthMessageOTP.messengerKeyOTP,
        home: Scaffold(
          backgroundColor: bgColor8,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: defaultMargin,
              ),
              child: Column(
                children: [
                  _header(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _textFieldOTP(
                          first: true,
                          last: false,
                          getValueEachOTP: OTP_1..text,
                          focusSide: textSecondFocusNode,
                          NodeNow: textFirstFocusNode),
                      _textFieldOTP(
                          first: false,
                          last: false,
                          getValueEachOTP: OTP_2..text,
                          focusSide: textThirdFocusNode,
                          NodeNow: textSecondFocusNode),
                      _textFieldOTP(
                          first: false,
                          last: false,
                          getValueEachOTP: OTP_3..text,
                          focusSide: textFourthFocusNode,
                          NodeNow: textThirdFocusNode),
                      _textFieldOTP(
                          first: false,
                          last: false,
                          getValueEachOTP: OTP_4..text,
                          focusSide: textFifthFocusNode,
                          NodeNow: textFourthFocusNode),
                      _textFieldOTP(
                          first: false,
                          last: false,
                          getValueEachOTP: OTP_5..text,
                          focusSide: textSixthFocusNode,
                          NodeNow: textFifthFocusNode),
                      _textFieldOTP(
                          first: false,
                          last: true,
                          getValueEachOTP: OTP_6..text,
                          focusSide: textSixthFocusNode,
                          NodeNow: textSixthFocusNode),
                    ],
                  ),
                  //WidgetAutoFilledOTP(),
                  TimerOTP(),
                  resendCode(),
                  // _buttonSubmit()
                  _buttonAlfi(),
                  _buttonAlfiLangsungMasuk()
                  //_buttonCheat(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
