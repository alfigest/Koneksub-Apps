import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waste_application/drop/model/droppoint_model.dart';
import 'package:waste_application/theme.dart';
import 'package:waste_application/drop/mapui.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher_string.dart';

class GPSPage extends StatefulWidget {
  const GPSPage({
    required this.distance,
    required this.options,
    required this.curent_position,
    Key? key,
  }) : super(key: key);
  final PartnerShip options;
  final String? distance;
  final LatLng? curent_position;

  @override
  State<GPSPage> createState() => _GPSPageState(
        options: options,
        distance: distance,
        curent_position: curent_position,
      );
}

class _GPSPageState extends State<GPSPage> {
  _GPSPageState({
    required this.distance,
    required this.options,
    required this.curent_position,
  });

  final PartnerShip options;
  final String? distance;
  final LatLng? curent_position;

  @override
  Widget build(BuildContext context) {
    final controller = PageController();
    final currentPageNotifier = ValueNotifier<int>(0);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: MapView(
                startLocation: curent_position!,
                endLocation:
                    LatLng(options.coord!.latitude, options.coord!.longitude)),
          ),
          SlidingUpPanel(
            panel: Column(
              children: [
                //SMALL BOX DECORATION
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 30),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  width: 75,
                  height: 5,
                ),

                //PAGE INDICATOR
                Container(
                  child: SmoothPageIndicator(
                    controller: controller,
                    count: 2,
                    effect: ScaleEffect(
                        dotHeight: 10,
                        dotWidth: 10,
                        dotColor: Colors.grey,
                        activeDotColor: Colors.green),
                  ),
                ),

                //THE PAGE VIEW
                Expanded(
                  child: PageView(
                    controller: controller,
                    onPageChanged: (int index) {
                      currentPageNotifier.value = index;
                    },
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.network(
                              options.image!,
                              width: 160,
                              height: 150,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //DISPLAY PARTNER NAME
                                Container(
                                  //padding: EdgeInsets.only(top: 0, right: 10.0),
                                  margin: EdgeInsets.only(top: 32),
                                  child: Text(options.name!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0)),
                                ),
                                //DISPLAY STATUS OF THE PARTNER
                                Container(
                                  padding: EdgeInsets.only(top: 15.0),
                                  child: Text('Status  : ' + options.status!,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15.0)),
                                ),
                                //DISPLAY ADDRESS OF THE PARTNER
                                Container(
                                  padding: EdgeInsets.only(top: 12.0),
                                  child: Text(
                                    'Jalan    : ' + options.address!,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15.0),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                //DISPLAY WA OF THE PARTNER
                                Container(
                                  padding: EdgeInsets.only(top: 12.0),
                                  child: Text(
                                    'WhatsApp   : ' + options.whatsapp!,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15.0),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                //DISPLAY Email OF THE PARTNER
                                Container(
                                  padding: EdgeInsets.only(top: 12.0),
                                  child: Text(
                                    'Email   : ' + options.email!,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15.0),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      //SECOND PAGE IN THE SLIDER UP
                      Column(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                top: 0, left: 25.0, bottom: 10.0),
                            child: Text(options.name!,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 25,
                              bottom: 15,
                            ),
                            child: Text(
                              "Jenis Sampah yang diterima oleh " +
                                  options.name! +
                                  " :",
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                for (int i = 0; i < options.trash!.length; i++)
                                  _trashtype(options.trash![i]),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 25,
                              bottom: 10,
                              right: 25,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Catatan : "),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                    "Harap buang isian pada sampah yang tergolong botol, cup dan kotak makanan agar Mitra tidak terkendala dalam memproses sampah Anda. Terimakasih."),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                //NAVIGATE BUTTON
                ElevatedButton(
                  onPressed: () async {
                    String mapUrl =
                        "https://www.google.com/maps/dir/?api=1&origin=&destination=${options.coord!.latitude},${options.coord!.longitude}&travelmode=driving&dir_action=navigate";
                    if (await canLaunchUrlString(mapUrl)) {
                      await launchUrlString(mapUrl,
                          mode: LaunchMode.externalApplication);
                    } else {
                      throw "Couldn't launch Map";
                    }
                  },
                  child: Text(
                    'Navigate | ' + distance!,
                    style: TextStyle(fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50.0),
                topRight: Radius.circular(50.0)),
            minHeight: 60.0,
            maxHeight: 355,
          )
        ],
      ),
    );
  }

  _trashtype(int number) {
    String? icon_path, trash_type;

    if (number == 1) {
      icon_path = "assets/trash/trash_plastics.png";
      trash_type = "Plastik";
    } else if (number == 2) {
      icon_path = "assets/trash/trash_paper.png";
      trash_type = "Kertas";
    } else if (number == 3) {
      icon_path = "assets/trash/trash_glass.png";
      trash_type = "Gelas";
    } else if (number == 4) {
      icon_path = "assets/trash/trash_can.png";
      trash_type = "Logam";
    }
    return Column(children: [
      Image.asset(
        "$icon_path",
        width: 26,
        height: 26,
      ),
      SizedBox(
        height: 5,
      ),
      Text("$trash_type"),
    ]);
  }
}
