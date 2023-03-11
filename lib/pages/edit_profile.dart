import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:waste_application/pages/profile_page.dart';
import 'package:waste_application/services_and_dataclass/sv_user_sgup.dart';
import 'package:waste_application/services_and_dataclass/username_login.dart';
import '../theme.dart';

class EditProfilePage extends StatefulWidget {
  final String email;

  const EditProfilePage({Key? key, required this.email}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  GlobalObjectKey<FormState> formKeyUsername = GlobalObjectKey<FormState>(1);

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  @override
  String imageUrl = "";
  bool adadsemail = false;
  String phone = "";

  @override
  void initState() {
    //telephoneController.text = DataUser.getUserPhone("lynn@gmail.com");
    getPfp();
    DataUser.getUserPhone(widget.email).then((value) {
      setState(() {
        phone = value;
      });
    });
    super.initState();
  }

  void ModalOption() async {
    await showMaterialModalBottomSheet(
        // isScrollControlled: true,
        bounce: true,
        // expand: false,
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 4,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                  child: const Text(
                    "Picture Source",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 89, 95),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    getImage_device("", "kamera");
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: const [
                        Icon(Icons.camera),
                        SizedBox(
                          width: 15,
                        ),
                        Text("Camera"),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  height: 1,
                  color: const Color.fromARGB(255, 240, 240, 240),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    getImage_device("", "galeri");
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: const [
                        Icon(Icons.picture_in_picture),
                        SizedBox(
                          width: 15,
                        ),
                        Text("Take from gallery"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<dynamic> getImage_device(String namaImage, String option) async {
    final image = "";
    final FirebaseStorage _storage = FirebaseStorage.instanceFor(
        bucket: "gs://wastemanagement-65034.appspot.com");
    if (option == "kamera") {
      final image = await ImagePicker().pickImage(
          source: ImageSource.camera,
          maxHeight: 512,
          maxWidth: 512,
          imageQuality: 70);

      final FirebaseAuth auth = FirebaseAuth.instance;

      final user = auth.currentUser;
      final uid = user!.uid;
      Reference ref = _storage.ref().child("users/images/$uid.png");

      await ref.putFile(File(image!.path));
      ref.getDownloadURL().then((value) {
        setState(() {
          imageUrl = value;
          print(value);
        });
      });
    } else if (option == "galeri") {
      final image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          maxWidth: 512,
          maxHeight: 512,
          imageQuality: 70);

      final FirebaseAuth auth = FirebaseAuth.instance;
      final user = auth.currentUser;
      final uid = user!.uid;
      Reference ref = _storage.ref().child("users/images/$uid.png");

      await ref.putFile(File(image!.path));
      ref.getDownloadURL().then((value) {
        setState(() {
          imageUrl = value;
          print(value);
        });
      });
    }

    // final FirebaseAuth auth = FirebaseAuth.instance;
    // final user = auth.currentUser;
    // final uid = user!.uid;
    // Reference ref = _storage.ref().child("users/images/$uid.png");

    // await ref.putFile(File(image!.path));
    // ref.getDownloadURL().then((value) {
    //   setState(() {
    //     imageUrl = value;
    //     print(value);
    //   });
    // } );
  }

  Future<void> updatePassword(String newpassword) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var user = _auth.currentUser;
    await user!
        .updatePassword(newpassword)
        .then((value) {})
        .whenComplete(() => print("Sukses update password baru"))
        .catchError((e) {
      print(e);
    });
  }

  Future<dynamic> getPfp() async {
    final FirebaseStorage _storage = FirebaseStorage.instanceFor(
        bucket: "gs://wastemanagement-65034.appspot.com");
    var defaultStorageRef =
        _storage.ref().child("users/images/blank_profile.png");
    imageUrl = await defaultStorageRef.getDownloadURL();

    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final uid = user!.uid;

    //diparsing biar cepet load
    var getProfileRef = _storage.ref().child("users/images/$uid.png");

    await getProfileRef.getDownloadURL().then((value) {
      if (value.isNotEmpty) {
        setState(() {
          imageUrl = value;
        });
      }
    }).catchError((e) {});
    return imageUrl;
  }

  void updateTelfon(String notelp) {
    DataUser.updateUserPhone(widget.email, notelp.toString());
  }

  // void updatePassword(String Newpassword) async{
  //   final FirebaseAuth auth = FirebaseAuth.instance;
  //   final user = auth.currentUser;

  //   user!.updatePassword(Newpassword)
  //   .whenComplete(()=> print("Berhasil di update passwordnya"))
  //   .catchError((e) => print("Password update error"));
  // }

  // Widget infoinfo() {
  //   return Text(
  //       "btw, emailnya belum dirubah karena ganti auth, sama firestorenya juga, hapus doc id lama, set doc id baru");
  // }

  Widget terima() {
    return ElevatedButton(
      onPressed: () {
        updateTelfon(telephoneController.text.toString());
        updatePassword(passwordController.text.toString());
      },
      child: Icon(Icons.check, color: Colors.white),
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(10),
        primary: Color(0xFF90CAF9), // <-- Button color
        onPrimary: Colors.green, // <-- Splash color
      ),
    );
  }

  void kosongkan() {
    setState(() {
      usernameController.text = "";
      emailController.text = "";
      telephoneController.text = "";
      passwordController.text = "";
    });
  }

  Widget tolak() {
    return ElevatedButton(
      onPressed: () {
        kosongkan();
      },
      child: Icon(Icons.cancel, color: Colors.white),
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(10),
        primary: Color(0xFF90CAF9), // <-- Button color
        onPrimary: Colors.red, // <-- Splash color
      ),
    );
  }

  Widget gambarOrang() {
    return GestureDetector(
      onTap: () {
        ModalOption();
      },
      child: ClipOval(
        child: imageUrl == ""
            ? Image.asset(
                'assets/image_profile.png',
                width: 20,
                height: 100,
              )
            : Image.network(
                imageUrl,
                width: 20,
                height: 100,
              ),
      ),
    );
  }

  Widget SaveOrCancel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [tolak(), terima()],
    );
  }

  Widget header() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Edit Profil',
            style: primaryTextStyle.copyWith(
              fontSize: 24,
              fontWeight: semiBold,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Ubah datamu disini ',
            style: subtitleTextStyle.copyWith(
              fontSize: 14,
              fontWeight: regular,
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget gabunganForm(String email) {
    return Container(
      child: Form(
        key: formKeyUsername,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //username start
            Text(
              'User Name',
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
                    // Image.asset(
                    //   'assets/email_icon.png',
                    //   width: 23,
                    // ),
                    Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        enabled: false,
                        controller: usernameController
                          ..text = getEmailUsername(widget.email),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Your Username',
                          hintStyle: subtitleTextStyle,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null && value.length < 6
                            ? 'Minimum user 6 character'
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            //username end

            //emailaddress start
            Text(
              'Email',
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
                        // onChanged: (text){
                        //  if (text.contains('@')){
                        //   print("ada ads");
                        //   adadsemail = true;
                        //  }
                        //  else if (adadsemail = false){
                        //   usernameController.text += text;
                        //  }
                        // },

                        controller: emailController..text = widget.email,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Alamat Email Kamu',
                          hintStyle: subtitleTextStyle,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
              'No. Telp',
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
                    // Image.asset(
                    //   'assets/email_icon.png',
                    //   width: 23,
                    // ),
                    Icon(
                      Icons.phone,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: telephoneController..text = phone,
                        //.collapsed
                        decoration: InputDecoration.collapsed(
                          hintText: 'Masukkan Nomor Telpon Kamu',
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
              'Kata Sandi',
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
                                  ) // icon
                                : Icon(
                                    Icons.visibility,
                                    size: 23,
                                  ),
                          ),
                          border: InputBorder.none,
                          hintText: 'Masukkan Kata Sandi Yang Baru',
                          hintStyle: subtitleTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: regular,
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null && value.length < 6
                            ? 'Enter minimum 6 char'
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
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // var ProfileUsername = ModalRoute.of(context)!.settings.arguments as LoginInfo;
    //var getEmail = ProfileUsername.email.toString();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: bgColor8,
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: defaultMargin),
                child: Column(
                  children: [
                    header(),
                    SaveOrCancel(),
                    gambarOrang(),
                    gabunganForm(""),
                  ],
                ),
              ),
            )));
  }
}
