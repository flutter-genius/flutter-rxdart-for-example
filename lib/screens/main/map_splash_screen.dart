import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/utils/routes.dart';
import 'package:hittapa/widgets/radar_scan.dart';
class MapSplashScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  MapSplashScreen({@required this.latitude, @required this.longitude});

  @override
  _MapSplashScreenState createState() => _MapSplashScreenState();
}

class _MapSplashScreenState extends State<MapSplashScreen> {
  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    super.initState();
    final int markerCount = markers.length;

    if (markerCount == 12) {
      return;
    }

    final String markerIdVal = 'marker_id_hittapa';
    final MarkerId markerId = MarkerId(markerIdVal);
    bitmapDescriptorFromSvgAsset(context, 'assets/hittapa_logo.svg')
        .then((value) {
      final Marker marker = Marker(
          markerId: markerId,
          position: LatLng(
            widget.latitude,
            widget.longitude,
          ),
          infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
          icon: value);
      setState(() {
        markers[markerId] = marker;
      });
      // loadCategories(); has been replaced by Firestore stream
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: MediaQuery.of(context).size.height/2 - MediaQuery.of(context).size.width/3,
            left: MediaQuery.of(context).size.width/6, 
            child: Container(
              width: MediaQuery.of(context).size.width/3*2,
              height: MediaQuery.of(context).size.width/3*2,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width/3*2)),
                child: Align(
                  alignment: Alignment.center,
                  child: GoogleMap(
                    scrollGesturesEnabled: false,
                    myLocationButtonEnabled: false,
                    onMapCreated: _onCreateMap,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(widget.latitude, widget.longitude), zoom: 11),
                    // markers: Set<Marker>.of(markers.values),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height/2 - MediaQuery.of(context).size.width/5*4,
            left: 0, 
            child: Container(
              width: MediaQuery.of(context).size.width-20,
              height: MediaQuery.of(context).size.width-20,
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: RadarPage(latitude: widget.latitude, longitude: widget.longitude),
            ),
          ),
        ]
      ),
    );
  }

  _onCreateMap(GoogleMapController controller) async {
    mapController = controller;
    refresh();
  }

  void refresh() async {
    mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(widget.latitude, widget.longitude), zoom: 15.0)))
        .then((value) => Navigator.pushNamedAndRemoveUntil(context, Routes.MAIN, (Route<dynamic> route) => false));
  }
}
