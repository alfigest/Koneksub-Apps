// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:validators/validators.dart' as validator;

import 'package:waste_application/pages/sign_in_page.dart';
import 'package:waste_application/pages/verify_user_email.dart';
import 'package:waste_application/services_and_dataclass/dc_user_sgup.dart';
import 'package:waste_application/services_and_dataclass/sv_user_sgup.dart';
import 'package:waste_application/services_and_dataclass/username_login.dart';
import 'package:waste_application/theme.dart';
import 'package:waste_application/utils/auth_message.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //revisi duplicate globalkey https://stackoverflow.com/questions/49371221/duplicate-globalkey-detected-in-widget-tree

  GlobalObjectKey<FormState> formKey = GlobalObjectKey<FormState>(1);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordControllerKonfirmasi = TextEditingController();
  TextEditingController telephoneController = TextEditingController();

  bool _secureText = true;
  bool _secureTextKonfirmasi = true;

  //dokumentasi : Prefix-prefix noTelp yang ada di Indonesia, data dari wikipedia
  List<String> noTelp = [
    //cdma mobile wireless //yang ndak ada coba : 0891, 0843, dll

    "0887", "0888", "0889", "0827", '0828', '0881', '0882', '0883', '0884',
    '0885', '0886',
    //indosar im3
    '0814', '0815', '0816', '0855', '0856', '0857', '0858',

    //indosat 3
    '0895', '0896', '0897', '0898', '0899',

    //Telkomsel
    '0811', '0812', '0813', '0821', '0822', '0823', '0851', '0852', '0853',

    //XL
    '0817', '0818', '0819', '0859', '0874', '0878',

    //Axis
    '0831', '0832', '0833', '0838',

    //Smartfren
    '0881', '0882', '0883', '0884', '0885', '0886', '0887', '0888', '0889',

    //Berca Hayaperkasa
    '082', '087'
  ];

  //dokumentasi : Function untuk ngecek nomer telfon valid atau nggak
  bool validateNumber(String noTelpUser) {
    for (int i = 0; i < noTelp.length; i++) {
      if (noTelpUser.startsWith(noTelp[i]) && noTelpUser.length >= 11) {
        //dokumentasi : kalo nomer telefon prefixnya sama kayak yang ada di wikipedia, dan >=11 return true
        return true;
      }
    }
    return false;
  }

  showHide() {
    setState(() {
      if (_secureText == false) {
        _secureText = true;
      } else {
        _secureText = false;
      }
      if (_secureTextKonfirmasi == false) {
        _secureTextKonfirmasi = true;
      } else {
        _secureTextKonfirmasi = false;
      }
    });
  }

  //dokumentasi : Function untuk mengambil username person, username diambil dari substring email user, sebelum @
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

  AlertMsg(BuildContext context, String title, String message) {
    showAlertDialog() {
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {},
      );

      AlertDialog alert = AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          okButton,
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  var no_telp = "";

  //deprecated
  Future<void> isTelfonExist(String getNoTelpUser) async {
    //CollectionReference dataSgUp = FirebaseFirestore.instance.collection("UserDetail");
    // FirebaseFirestore.instance.collection("UserDetail").doc()
    //   .get().then((value) {
    //     var fields = value.data();
    //     print("woke masuk");
    //     print(fields!["phone_number"]);
    //   });
    // print("okee");
    // print("notelp : "+ no_telp);
  }

  @override
  void initState() {
    // TODO: implement initState
    isTelfonExist("");
    super.initState();
  }

  //sign up firebase
  //dokumentasi : Function sign up firebase
  Future signUpFirebase() async {
    final isValid = formKey.currentState!
        .validate(); //dokumentasi : Mengecek apakah semua form sudah valid dan benar

    if (!isValid) return;
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
                child: CircularProgressIndicator(),
              ));

      // showDialog(
      //     context: context,
      //     barrierDismissible: false,
      //     builder: (context) => Center(
      //         child: LoadingIndicator(
      //             indicatorType: Indicator.ballClipRotate,
      //             colors: const [Colors.yellow],
      //             strokeWidth: 1,
      //             backgroundColor: Colors.white,
      //             pathBackgroundColor: Colors.red)));

      //dokumentasi : Create sign up baru dengan data yang didaftarkan user di sign up
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.toString(),
              password: passwordController.text.toString())
          .catchError((e) {
        print("Error sign up adalah " + e);
        AlertMsg(context, "Tidak bisa sign in", e);
      });
      //dokumentasi : Input data ke Firestore juga, bisa di hover nama classnya untuk lihat path classnya, dan fucntionnya untuk Create new field di firestore
      final dataSignUp = userSignUp(
          username: getEmailUsername(emailController.text.toString()),
          email: emailController.text.toString(),
          phone_number: telephoneController.text.toString().substring(1));
      DataUser.addUsersData(
          data: dataSignUp, docID: emailController.text.toString());
      //pindah page to do ke verifikasi sign up dulu
      // Navigator.pushNamed(context, '/home',
      //     arguments: LoginInfo(emailController.text.toString()));

      FirebaseAuth
          .instance //dokumentasi : Lalu setelah user daftar, masuk function sign in agar masuk Firebaseauth juga
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((value) => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => VerifyEmailUser(
                        emailUser: emailController.text.toString(),
                        telephoneUser: telephoneController.text.toString(),
                      )))));
    } on FirebaseAuthException catch (e) {
      AlertMsg(context, "Tidak bisa", e.message.toString());
      AuthMessage.showSnackBar(e.message);
    } catch (e) {
      print("Catch " + e.toString());
      print("error");
    }
  }

  Widget gabunganFormAmbildariEditProfile() {
    return Container(
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //emailaddress start
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
                        controller: emailController..text,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Your Email Address',
                          hintStyle: subtitleTextStyle,
                        ),
                        //autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (email) =>
                            email != null && !EmailValidator.validate(email)
                                ? 'Enter a valid email'
                                : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            //emailaddress end

            //phone number start
            Text(
              'Phone Number',
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
                    Icon(
                      Icons.phone,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(13),
                        ],
                        validator: (notelp) {
                          if (notelp != null &&
                              validateNumber(notelp) == false) {
                            return "Wrong number, (start with 0 [11-13 digit])";
                          } else {
                            return null;
                          }
                        }
                        //=> notelp!=null && validateNumber(notelp) ==false && !(notelp.length >=11 && notelp.length<=13)? "Format phone number wrong, start with 0" : null,
                        ,
                        controller: telephoneController..text,
                        //.collapsed
                        decoration: InputDecoration.collapsed(
                          hintText: 'Your Phone Number',
                          hintStyle: subtitleTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            //phone number end

            //[password start]
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
                        controller: passwordController..text,
                        obscureText: _secureText,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: showHide,
                            icon: _secureText
                                ? Icon(
                                    Icons.visibility_off,
                                    size: 23,
                                  ) // icon
                                : Icon(
                                    Icons.visibility,
                                    size: 23,
                                    color: Colors.grey,
                                  ),
                          ),
                          border: InputBorder.none,
                          hintText: 'Input password',
                          hintStyle: subtitleTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: regular,
                          ),
                        ),
                        //autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null && value.length < 6
                            ? 'Enter minimum 6 character'
                            : null,
                        style: text_barStyle.copyWith(
                          fontSize: 14,
                          fontWeight: regular,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            //[password end]

            //[password2 start]
            Text(
              'Konfirmasi Password',
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
                        controller: passwordControllerKonfirmasi..text,
                        obscureText: _secureTextKonfirmasi,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: showHide,
                            icon: _secureTextKonfirmasi
                                ? Icon(
                                    Icons.visibility_off,
                                    size: 23,
                                    color: Colors.grey,
                                  ) // icon
                                : Icon(Icons.visibility,
                                    size: 23, color: Colors.grey),
                          ),
                          border: InputBorder.none,
                          hintText: 'Input password',
                          hintStyle: subtitleTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: regular,
                          ),
                        ),
                        //autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != passwordController.text
                            ? 'Password harus sama dengan yang atas'
                            : null,
                        style: text_barStyle.copyWith(
                          fontSize: 14,
                          fontWeight: regular,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            //[password2 end]

            //button start

            Container(
              height: 60,
              width: double.infinity,
              margin: EdgeInsets.only(top: 30),
              child: TextButton(
                // onPressed: signUpFirebase,
                onPressed: () {
                  signUpFirebase();
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyEmailUser(),));
                  //Navigator.pushNamed(context, '/home');
                },
                style: TextButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Sign Up',
                  style: button_TextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: bold,
                  ),
                ),
              ),
            ),
            //button end
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sign Up',
            style: primaryTextStyle.copyWith(
              fontSize: 24,
              fontWeight: semiBold,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Register ',
            style: subtitleTextStyle.copyWith(
              fontSize: 14,
              fontWeight: regular,
            ),
          ),
          SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _button() {
    return Container(
      height: 60,
      width: double.infinity,
      margin: EdgeInsets.only(top: 30),
      child: TextButton(
        // onPressed: signUpFirebase,
        onPressed: () {
          signUpFirebase();
        },
        style: TextButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Sign Up',
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
            'Already have an account? ',
            style: subtitleTextStyle.copyWith(
              fontSize: 12,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/sign-in');
            },
            child: Text(
              'Sign In',
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

  //buat allert dialog

  Future<bool> _onWillPop() async {
    //dokumentasi : onWillPop Override back button function
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    //Ngilangin keyboard kalo layar disentuh pas sign up / sign in
    return GestureDetector(
      //detect kalo ada sentuhan
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context); //ngambil focusnya
        if (!currentFocus.hasPrimaryFocus) {
          //kalo focusnya punya primaryfocus(state ngga ada keyboard)
          currentFocus.unfocus(); //buat di state gak ada keyboard
        }
      },
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
              backgroundColor: bgColor8,
              resizeToAvoidBottomInset: false,
              body: SafeArea(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: defaultMargin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _header(),
                      gabunganFormAmbildariEditProfile(),
                      Spacer(),
                      _footer()
                    ],
                  ),
                ),
              ))),
    );
  }
}
