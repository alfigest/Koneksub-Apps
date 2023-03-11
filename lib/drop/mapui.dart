import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waste_application/theme.dart';

class MapView extends StatefulWidget {
  const MapView({required this.startLocation, required this.endLocation});

  final LatLng startLocation, endLocation;

  @override
  State<MapView> createState() =>
      _MapViewState(startLocation: startLocation, endLocation: endLocation);
}

class _MapViewState extends State<MapView> {
  _MapViewState({
    required this.startLocation,
    required this.endLocation,
  });

  GoogleMapController? mapController; //controller for Google map
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey =
      "AIzaSyCkoZat0Qep754cgH-hWly8mrDi_gniw-o"; //API Key Wong

  Set<Marker> markers = Set(); //markers for google map
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

  LatLng? startLocation, endLocation;

  Uint8List? userIcon, finishIcon;

  @override
  void initState() {
    //Icon for start and finish markers
    getBytesFromAsset("assets/home-pin.png", 125).then((value) {
      userIcon = value;
    });
    // BitmapDescriptor.fromAssetImage(
    //         ImageConfiguration(size: Size(10, 10)), "assets/icons/user.png")
    //     .then((value) {
    //   userIcon = value;
    // });

    //destination location marker
    getBytesFromAsset("assets/location-pin.png", 125).then((value) {
      finishIcon = value;
    });
    // BitmapDescriptor.fromAssetImage(ImageConfiguration(size: ),
    //         'assets/icons/racing-flag.png')
    //     .then((value) {
    //   finishIcon = value;
    // });

    getDirections(); //fetch direction polylines from Google API

    super.initState();
  }

  getDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(startLocation!.latitude, startLocation!.longitude),
      PointLatLng(endLocation!.latitude, endLocation!.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: bgColor1,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  checkRelativePos(LatLng start, LatLng destination) {
    double miny = (start.latitude <= destination.latitude)
        ? start.latitude
        : destination.latitude;
    double minx = (start.longitude <= destination.longitude)
        ? start.longitude
        : destination.longitude;
    double maxy = (start.latitude <= destination.latitude)
        ? destination.latitude
        : start.latitude;
    double maxx = (start.longitude <= destination.longitude)
        ? destination.longitude
        : start.longitude;

    var bound = LatLngBounds(
      southwest: LatLng(miny, minx),
      northeast: LatLng(maxy, maxx),
    );

    return bound;
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    //start location marker
    markers.add(Marker(
      markerId: MarkerId(startLocation.toString()),
      position: startLocation!, //position of marker
      infoWindow: const InfoWindow(
        //popup info
        title: 'Starting Point ',
        snippet: 'Start Marker',
      ),
      icon: userIcon == null
          ? BitmapDescriptor.defaultMarker
          : BitmapDescriptor.fromBytes(userIcon!), //Icon for Marker
    ));

    //destination location marker
    markers.add(Marker(
        markerId: MarkerId(endLocation.toString()),
        position: endLocation!, //position of marker
        infoWindow: const InfoWindow(
          //popup info
          title: 'Destination Point ',
          snippet: 'Destination Marker',
        ),
        icon: finishIcon == null
            ? BitmapDescriptor.defaultMarker
            : BitmapDescriptor.fromBytes(finishIcon!) //Icon for Marker
        ));
    return Scaffold(
      body: GoogleMap(
        //Map widget from google_maps_flutter package
        scrollGesturesEnabled: false,
        zoomControlsEnabled: false,
        zoomGesturesEnabled: false,
        //enable  Zoom in, out on map
        initialCameraPosition: CameraPosition(
          //innital position in map
          target: startLocation!,
          // LatLng(
          //     ((startLocation!.latitude + endLocation!.latitude) / 2),
          //     ((startLocation!.longitude + endLocation!.longitude) /
          //         2)), //initial position (Have to be center of the polyline, not between 2 point)
          //initial zoom level (Still use manual set)
          zoom: 11,
        ),

        markers: markers,
        //markers to show on map
        polylines: Set<Polyline>.of(polylines.values),
        //polylines
        mapType: MapType.normal,
        //map type

        onMapCreated: (controller) {
          //method called when map is created
          setState(() {
            mapController = controller;
          });
        },
        onTap: (argument) {
          mapController!.animateCamera(
            CameraUpdate.newLatLngBounds(
              checkRelativePos(startLocation!, endLocation!),
              120,
            ),
          );
        },
      ),
    );
  }
}
