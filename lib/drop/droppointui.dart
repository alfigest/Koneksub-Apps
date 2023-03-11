import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waste_application/drop/model/droppoint_model.dart';
import 'package:waste_application/drop/viewmodel/droppoint_view_model.dart';
import 'package:waste_application/theme.dart';
import 'package:waste_application/drop/gpsui.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:waste_application/data/response/status.dart';

class DropPointPage extends StatefulWidget {
  const DropPointPage({Key? key}) : super(key: key);

  @override
  State<DropPointPage> createState() => _DropPointPageState();
}

class _DropPointPageState extends State<DropPointPage> {
  PartnerShipViewViewModel partnerShipViewViewModel =
      PartnerShipViewViewModel();
  bool servicestatus = false;
  bool haspermission = false;
  bool firstLoad = true;
  late LocationPermission permission;
  Position? position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;
  List<double> totalDistance = [];
  List<PartnerShip> original = [], second = [];
  @override
  void initState() {
    // TODO: implement initState
    partnerShipViewViewModel.fecthPartnerShipsApi();
    //original = partnerShipViewViewModel.partnerShips.data!.partnerShips!;
    super.initState();
    checkGps();
    // Provider.of<PartnerShipListViewModel>(context, listen: false).getAll();
  }

  @override
  Widget build(BuildContext context) {
    // final vm = Provider.of<PartnerShipListViewModel>(context);

    Widget _search() {
      return Container(
        margin: EdgeInsets.only(
            left: defaultMargin, right: defaultMargin, top: 100),
        child: TextField(
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.zero,
              child: Icon(
                Icons.search,
                //color: Colors.black,
              ),
            ),
            hintText: 'Area Domisili Anda',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onChanged: (value) {
            final suggestion = original.where((name) {
              final partnerName = name.name!.toLowerCase();
              final input = value.toLowerCase();
              return partnerName.contains(input);
            }).toList();
            setState(() {
              second = suggestion;
              print(second.length);
            });
          },
        ),
      );
    }

    //final getProfileRef = _storage.ref().child("partners");
    //vm.partners = sortPartner(vm, totalDistance);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Drop Point Area',
          style: primaryTextStyle.copyWith(
            fontSize: 23,
            fontWeight: semiBold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: Container(
        child: ChangeNotifierProvider<PartnerShipViewViewModel>(
          create: (context) => partnerShipViewViewModel,
          child: Consumer<PartnerShipViewViewModel>(
            builder: (BuildContext context, value, __) {
              switch (value.partnerShips.status) {
                case Status.LOADING:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case Status.COMPLETED:
                  //print("Before:" + original.isEmpty.toString());
                  if (firstLoad) {
                    firstLoad = false;
                    original = value.partnerShips.data!.partnerShips!;
                    //second = getDistance(original, original.length);
                    print(totalDistance.length);
                  } else {
                    if (second.isEmpty) {
                      second = getDistance(original, original.length);
                    }
                  }

                  //print("After:" + original.isEmpty.toString());
                  return Scaffold(
                    body: RefreshIndicator(
                      onRefresh: () => _refresh(second, second.length),
                      color: Colors.black,
                      displacement: 50,
                      strokeWidth: 3,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          _search(),
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.only(top: 25),
                              itemCount: second.length == 0
                                  ? original.length
                                  : second.length,
                              itemBuilder: (context, index) {
                                final partner;
                                if (totalDistance.isNotEmpty) {
                                  partner = second[index];
                                  //print(vm.partners[index].name);
                                  return RoundBox(
                                    first: index == 0 ? true : false,
                                    options: partner,
                                    distance:
                                        totalDistance[index].toStringAsFixed(0),
                                    current_position: position!,
                                    // files[files.indexWhere((element) =>
                                    //     element.name.split('.')[0] ==
                                    //     partner.id.toString())],
                                  );
                                } else {
                                  return Center(
                                    child: LoadingAnimationWidget
                                        .horizontalRotatingDots(
                                            color: Colors.black, size: 25),
                                  );
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                case Status.ERROR:
                  return const Center(
                    child: Text('Error Fetch',
                        style: TextStyle(color: Colors.red)),
                  );
                default:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> _refresh(List<PartnerShip> partners, int limit) async {
    await Future.delayed(
      Duration(seconds: 3),
    );

    // listData.clear();
    // await Future.delayed(Duration(seconds: 2));
    // for (var index = 0; index < 10; index++) {
    //   var nama = 'User ${index + 1}';
    //   var nomor = Random().nextInt(100);
    //   listData.add(User(nama, nomor));
    // }
    setState(() {
      partners = getDistance(partners, limit);
      //print(totalDistance);
    });
  }

  getDistance(List<PartnerShip> partners, int limit) {
    if (position != null && partners.isNotEmpty) {
      totalDistance.clear();
      for (var i = 0; i < limit; i++) {
        totalDistance.add(Geolocator.distanceBetween(
            position!.latitude,
            position!.longitude,
            partners[i].coord!.latitude,
            partners[i].coord!.longitude));
      }
      // print(position!.latitude);
      // print(position!.longitude);
      // setState(() {
      //   partners = sortPartner(partners, totalDistance);
      // });
      return sortPartner(partners, totalDistance);
    } else {
      return <PartnerShip>[];
    }
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        setState(() {});

        getLocation();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {
      //refresh the UI
    });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // print(position.longitude); //Output: 80.24599079
    // print(position.latitude); //Output: 29.6593457

    long = position!.longitude.toString();
    lat = position!.latitude.toString();

    setState(() {
      //refresh UI
    });

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      // print(position.longitude); //Output: 80.24599079
      // print(position.latitude); //Output: 29.6593457

      long = position.longitude.toString();
      lat = position.latitude.toString();

      setState(() {
        //refresh UI on update
      });
    });
  }

  sortPartner(List<PartnerShip> partners, List<double> distancetest) {
    List<PartnerShip> temp = List.from(partners);
    final Map<double, PartnerShip> mapping = {
      for (int i = 0; i < distancetest.length; i++) distancetest[i]: temp[i]
    };
    distancetest.sort();
    temp = [for (double d in distancetest) mapping[d]!];
    // for (var i = 0; i < temp.length; i++) {
    //   print(temp[i].name);
    // }
    return temp;
  }
}

class RoundBox extends StatelessWidget {
  const RoundBox(
      {required this.options,
      required this.distance,
      required this.first,
      required this.current_position,
      Key? key})
      : super(key: key);
  final Position current_position;
  final PartnerShip options;
  final String? distance;
  final bool? first;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GPSPage(
              options: options,
              distance: distance,
              curent_position:
                  LatLng(current_position.latitude, current_position.longitude),
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Stack(
          children: [
            Container(
              //width: 500,
              decoration: BoxDecoration(
                // image: DecorationImage(
                //   image: NetworkImage(url!),
                //   alignment: Alignment.centerLeft,
                //   //fit: BoxFit.fill,
                // ),
                color: Colors.white60,
                border: Border.all(
                  color: Colors.transparent,
                ),
                boxShadow: [
                  BoxShadow(
                    color: first == true ? Colors.red : Colors.green,
                    spreadRadius: 0.5,
                    blurRadius: 5,
                    offset: Offset.zero,
                  ),
                  BoxShadow(
                    color: Colors.white,
                    offset: const Offset(0.0, 0.0),
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              padding: EdgeInsets.only(left: 0, top: 0, right: 25, bottom: 0),
              margin: EdgeInsets.only(
                top: defaultMargin,
                left: defaultMargin,
                right: defaultMargin,
              ),
              child: Row(
                children: [
                  ClipRRect(
                    //padding: EdgeInsets.only(right: 15),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    child: Image.network(
                      options.image!,
                      width: 115,
                      height: 120,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //DISPLAY PARTNER NAME
                        Container(
                          //padding: EdgeInsets.only(top: 0, right: 10.0),
                          child: Text(options.name!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0)),
                        ),
                        // Expanded(
                        //     child: Container(
                        //   width: 50,
                        //   color: Colors.red,
                        // )),
                        //DISPLAY STATUS OF THE PARTNER
                        Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text('Status : ' + options.status!,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 15.0)),
                        ),
                        //DISPLAY ADDRESS OF THE PARTNER
                        Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                            options.address!,
                            style:
                                TextStyle(color: Colors.black, fontSize: 15.0),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            top: 15, left: 10, bottom: 5.0, right: 0),
                        child: Text(
                            (double.parse(distance!) / 1000) < 1
                                ? '$distance'
                                : (double.parse(distance!) / 1000)
                                    .toStringAsFixed(0),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 23.0)),
                      ),
                      Container(
                        padding:
                            EdgeInsets.only(top: 5.0, bottom: 5.0, left: 15),
                        child: Text(
                            (double.parse(distance!) / 1000) < 1 ? 'M' : 'KM',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 23.0)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            first == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Card(
                        margin: EdgeInsets.only(top: 10, right: 5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        elevation: 3,
                        color: Colors.red,
                        child: Container(
                          padding: EdgeInsets.only(left: 13, top: 2),
                          width: 80,
                          height: 20,
                          child: Text(
                            "Terdekat",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
