import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/services/cloud_firestore_service.dart';
import 'package:hittapa/widgets/locations_view.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';

final kGoogleApiKey = "AIzaSyBE-5QgYsnFaBUSUR8LL7f-IETuPc29frs";

class HittapaPlaceSearchBox extends PlacesAutocompleteWidget {
  HittapaPlaceSearchBox({String userId})
      : super(
          apiKey: 'AIzaSyCjpgBMTPJhCEw6Yi0kP_8ECx4LMR0ZbCc',
          sessionToken: Uuid().generateV4(),
          language: "en",
          userId: userId,
          components: [
//            Component(Component.country, "uk"),
//            Component(Component.country, 'us'),
//            Component(Component.country, "se"),
//            Component(Component.country, 'pl')
          ],
        );

  @override
  _HittapaPlaceSearchBoxState createState() => _HittapaPlaceSearchBoxState();
}

class _HittapaPlaceSearchBoxState extends PlacesAutocompleteState {
// to get places detail (lat/lng)
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final searchScaffoldKey = GlobalKey<ScaffoldState>();
  SolidController _controller = SolidController();
  Address selectedAddress;
  GoogleMapsPlaces _places;
  GoogleMapController mapController;
  bool _isListExpended = false;

  @override
  void initState() {
    super.initState();
    _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      _getPlaceByCoordinate(value.latitude, value.longitude);
      refresh(value.latitude, value.longitude);
      markPlace(value.latitude, value.longitude);
      Timer(Duration(seconds: 3), () => _controller.show());
    });
  }

  markPlace(double lat, double lng) {
    final String markerIdVal = 'marker_id_hittapa';
    final MarkerId markerId = MarkerId(markerIdVal);
    bitmapDescriptorFromSvgAsset(context, 'assets/hittapa_logo.svg')
        .then((value) {
      final Marker marker = Marker(
          markerId: markerId,
          position: LatLng(
            lat,
            lng,
          ),
          infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
          icon: value);
      setState(() {
        markers[markerId] = marker;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final body = PlacesAutocompleteResult(
      onTap: (p) {
        displayPrediction(p, searchScaffoldKey.currentState);
        setState(() {
          _isListExpended = false;
          FocusScope.of(context).requestFocus(new FocusNode());
        });
        Timer(Duration(seconds: 2), () => _controller.show());
      },
      isExpended: _isListExpended,
    );
    return Scaffold(
      key: searchScaffoldKey,
      backgroundColor: Colors.transparent,
//        appBar: appBar,
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onTap: (value) {
              markPlace(value.latitude, value.longitude);
            },
            onMapCreated: _onCreateMap,
            initialCameraPosition:
                CameraPosition(target: LatLng(0.0, 0.0), zoom: 11),
            markers: Set<Marker>.of(markers.values),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 17, right: 17, left: 7),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: SvgPicture.asset('assets/arrow-back.svg'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Container(
                        height: 50,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: const Color(0xFF696969),
                                spreadRadius: -7,
                                blurRadius: 14,
                              ),
                            ],
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: AppBarPlacesAutoCompleteTextField(
                          hintText: selectedAddress != null
                              ? '${selectedAddress.addressLine}'
                              : 'Search your meeting point address',
                          onChanged: () {
                            setState(() {
                              _isListExpended = true;
                            });
                          },
//                            focusNode: _focusNode,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 70, right: 17, left: 17),
            child: _isListExpended
                ? body
                : SizedBox(
                    height: 0,
                  ),
          ),
        ],
      ),
      bottomSheet: SolidBottomSheet(
        controller: _controller,
        maxHeight: MediaQuery.of(context).size.height / 2,
        headerBar: Container(
          decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: const Color(0xFF696969),
                  spreadRadius: -5,
                  blurRadius: 14,
                ),
              ],
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40), topLeft: Radius.circular(40)),
              color: Colors.white),
          height: 60,
          child: Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 15),
              width: 45,
              height: 6,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  color: CIRCLE_AVATAR_COLOR),
            ),
          ),
        ),
        body: LocationsView(
          currentAddress: selectedAddress,
          userId: FirebaseId(widget.userId),
        ),
      ),
    );
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;

      refresh(lat, lng);
      markPlace(lat, lng);
    }
  }

  _onCreateMap(GoogleMapController controller) async {
    mapController = controller;
  }

  void refresh(double latitude, double longitude) async {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude), zoom: 15.0)));
    _getPlaceByCoordinate(latitude, longitude);
  }

  void _getPlaceByCoordinate(double lat, double lon) async {
// From coordinates
    final coordinates = Coordinates(lat, lon);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      selectedAddress = addresses.first;
    });
  }
}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}
