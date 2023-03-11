// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:waste_application/theme.dart';

// import '../services_and_dataclass/sv_mitra.dart';

// class MitraDetailPage extends StatefulWidget {
//   final String QRCodeResult;
//   const MitraDetailPage({Key? key, required this.QRCodeResult})
//       : super(key: key);

//   @override
//   State<MitraDetailPage> createState() => _MitraDetailPageState();
// }

// class _MitraDetailPageState extends State<MitraDetailPage> {
//   Widget QRCodeResult() {
//     return Expanded(
//       child: StreamBuilder<QuerySnapshot>(
//           stream: DataMitra.getSpecificMitraData(widget.QRCodeResult),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Text("Error");
//             } else if (snapshot.hasData || snapshot.data != null) {
//               return ListView(
//                 children: [Text("asd")],
//               );
//             }
//             return Text("");
//           }),
//     );
//   }

//   Widget AddPhotos(){
//     return  IconButton(onPressed: (){
//       showBtmModal();
//     }, icon: Icon(Icons.add_box, color: Colors.grey, size: 50,));
//   }
//   File? image;
//   Future ambilGambar  (String pilihan) async{
//     if (pilihan == "Galeri"){
//       try {
//       final image = await ImagePicker().pickImage(source: ImageSource.gallery);

//       if (image == null) {
//         print("Image is Empty");
//         return;
//       }

//       final imageTemp = File(image.path);
//       setState(() {
//         this.image = imageTemp;
//       });
//     } on PlatformException catch (e) {
//       print('Failed to pick image: $e');
//     }
//     }
//     else{
//       try {
//       final image = await ImagePicker().pickImage(source: ImageSource.camera);

//       if (image == null) {
//         print("Image is Empty");
//         return;
//       }

//       final imageTemp = File(image.path);
//       setState(() {
//         this.image = imageTemp;
//       });
//     } on PlatformException catch (e) {
//       print('Failed to pick image: $e');
//     }
//     }
//   }

//   void showBtmModal() async {
//   await showMaterialModalBottomSheet(
//       // isScrollControlled: true,
//       bounce: true,
//       // expand: false,
//       context: context,
//       builder: (context) {
//         return Container(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(
//                 height: 15,
//               ),
//               GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Center(
//                   child: Container(
//                     width: 100,
//                     height: 4,
//                     decoration: const BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(5),
//                         topRight: Radius.circular(5),
//                         bottomLeft: Radius.circular(5),
//                         bottomRight: Radius.circular(5),
//                       ),
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
//                 child: const Text(
//                   "Picture Source",
//                   overflow: TextOverflow.ellipsis,
//                   maxLines: 1,
//                   softWrap: false,
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Color.fromARGB(255, 0, 89, 95),
//                   ),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);
//                   ambilGambar("Kamera");
//                 },
//                 child: Container(
//                   color: Colors.transparent,
//                   padding: const EdgeInsets.all(15),
//                   child: Row(
//                     children: const[
//                       Icon(Icons.camera),
//                       SizedBox(
//                         width: 15,
//                       ),
//                       Text("Camera"),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
//                 height: 1,
//                 color: const Color.fromARGB(255, 240, 240, 240),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);
//                   ambilGambar("Galeri");
//                 },
//                 child: Container(
//                   color: Colors.transparent,
//                   padding: EdgeInsets.all(15),
//                   child: Row(
//                     children: const [
//                       Icon(Icons.picture_in_picture),
//                       SizedBox(
//                         width: 15,
//                       ),
//                       Text("Take from gallery"),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//         home: Scaffold(
//             body: Column(children: [
     
//         Flexible(
//            child: StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance.collection("mitra").orderBy("id").startAt([widget.QRCodeResult]).endAt([widget.QRCodeResult]).snapshots(),
//             builder: ((context, snapshot) {
//               if (!snapshot.hasData) {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               } else {
//                 return Card(
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                       itemBuilder: (((context, index) {
//                         DocumentSnapshot dsData = snapshot.data!.docs[index];
//                         String namaMitra = dsData["nama_mitra"];
//                         return ListTile(
                        
//                           tileColor: Colors.white,
//                           title: new Center(child : Text(namaMitra , style: TextStyle(fontSize:30),)),
//                         );
//                       })),
//                       itemCount: snapshot.data!.docs.length,
//                      ),
//                 );
//               }
//             }),
//                  ),
//          ),
//       SizedBox(height : 50.0),
//       Text("Scan QR Code berhasil!", style: TextStyle(fontSize: 20),),
//       Text("Sematkan ini pada kantung sampah", style: TextStyle(fontSize: 20),),
//       Text("Anda dan upload fotonya disini", style: TextStyle(fontSize: 20),),
//       SizedBox(height: 20,),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           for (int i=0; i<4;i++)
//             AddPhotos()
//         ],
        
//       ),
//       SizedBox(height: 50,),
//       ElevatedButton(onPressed: (){}, child: Text("Selanjutnya"))
//     ])));
//   }
// }
