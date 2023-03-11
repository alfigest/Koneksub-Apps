import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waste_application/theme.dart';

class DropSuksesDetail extends StatefulWidget {
  final String gambarFirestoreID;

  final String mitra;
  final String hari; 
  final String point;
  const DropSuksesDetail({Key? key, required this.gambarFirestoreID,
  required this.mitra, required this.hari, required this.point}) : super(key: key);

  @override
  State<DropSuksesDetail> createState() => _DropSuksesDetailState();
}


class _DropSuksesDetailState extends State<DropSuksesDetail> {
  int _current = 0;
   final CarouselController _controller = CarouselController();
  List <String> imageFirebaseFirebase = [];
  List <String> imageKosong = ["https://icon2.cleanpng.com/20180605/ijl/kisspng-computer-icons-image-file-formats-no-image-5b16ff0d2414b5.0787389815282337411478.jpg"];
  @override
  void initState() {
    //loadImages(widget.gambarFirestoreID);
    loadImages(widget.gambarFirestoreID);
    super.initState();
  }

  Widget cardcard(String textDetail){
    return Card(
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
          child: Text(textDetail),
        ),
      ),
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
    );
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text("Detail Drop History"),
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () { 
            Navigator.pop(context);
           },)
        ),
        body : Container(
          padding: EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Text("Firestore ID : " + widget.gambarFirestoreID),
               CarouselSlider(
                carouselController: _controller,
                  items: imageFirebaseFirebase.isNotEmpty?
                  imageFirebaseFirebase
                      .map(
                        (image) => Image.network(
                          image,
                          width: MediaQuery.of(context).size.width,
                          height: 310,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                      .toList():
                     imageKosong
                      .map(
                        (image) => Image.network(
                          image,
                          width: MediaQuery.of(context).size.width,
                          height: 310,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                      .toList()
                      ,
                  options: CarouselOptions(
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                     // enableInfiniteScroll: false,
                      initialPage: 0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imageFirebaseFirebase.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 12.0,
                        height: 12.0,
                        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black)
                                .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                      ),
                    );
                  }).toList(),
                ),
              
            
                
                cardcard("Mitra : ${widget.mitra}"),cardcard("Hari : ${widget.hari}"),cardcard("Point Didapatkan : ${widget.point}"), 
            ],
          )
        )
      ),
    );
  }

  //get function image from wong
  void loadImages(String id) async {
    await FirebaseFirestore.instance.collection("dataSetorSampah").doc(widget.gambarFirestoreID).get().then((value) {
      setState(() {
        List.from(value['imageLink']).forEach((element) {
          print("Get gambar link :" + element.toString());
          imageFirebaseFirebase.add(element.toString());
        });
      });
    });
  }
}