import 'package:flutter/material.dart';
import 'package:waste_application/main.dart';

import 'home/main_page.dart';
class SplashDrop extends StatefulWidget {
  final String username;
  const SplashDrop({Key? key, required this.username}) : super(key: key);

  @override
  State<SplashDrop> createState() => _SplashDropState();
}

class _SplashDropState extends State<SplashDrop> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Container(
          padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
          child: Column(
            children: [
              Image.asset("assets/sampah_thumbsup.png"),
              SizedBox(
                height: 60,
              ),
              Center(
                child: Container(
                    padding: EdgeInsets.all(40),
                    child: Text(
                      "Donor sampahmu telah berhasil.\nSilahkan lakukan pengecekan status sampah\ndi Drop History untuk mendapatkan point",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
              ElevatedButton(onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => MainPage(
                          Main_EmailUser: widget.username,
                        ))));
              }, child: Text("Kembali ke home"))
            ],
          ),
        )));
  }
}
