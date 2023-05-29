import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/widgets/hittapa_outline.dart';
import 'package:hittapa/widgets/place_search.dart';
import 'package:hittapa/global_export.dart';

final kGoogleApiKey = "AIzaSyBE-5QgYsnFaBUSUR8LL7f-IETuPc29frs";

class PickUserLocationScreen extends PlacesAutocompleteWidget {
  PickUserLocationScreen()
      : super(
          apiKey: 'AIzaSyCjpgBMTPJhCEw6Yi0kP_8ECx4LMR0ZbCc',
          sessionToken: Uuid().generateV4(),
          language: "en",
          components: [],
        );

  @override
  _PickUserLocationScreenState createState() => _PickUserLocationScreenState();
}

class _PickUserLocationScreenState extends PlacesAutocompleteState {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final searchScaffoldKey = GlobalKey<ScaffoldState>();
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
      refresh(value.latitude, value.longitude);
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
    globalContext = context;
    final body = PlacesAutocompleteResult(
      onTap: (p) {
        displayPrediction(p, searchScaffoldKey.currentState);
        setState(() {
          _isListExpended = false;
          FocusScope.of(context).requestFocus(new FocusNode());
        });
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
            onMapCreated: _onCreateMap,
            onTap: (value) {
              markPlace(value.latitude, value.longitude);
            },
            initialCameraPosition:
                CameraPosition(target: LatLng(0.0, 0.0), zoom: 11),
            markers: Set<Marker>.of(markers.values),
          ),
          SafeArea(
            child: Container(
              margin: EdgeInsets.only(top: 17, right: 17, left: 7),
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
                              : LocaleKeys.event_search_meeting.tr(),
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
          Positioned(
            bottom: 0,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: const Color(0xFF696969),
                      spreadRadius: -5,
                      blurRadius: 14,
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40))),
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40),
                            topLeft: Radius.circular(40)),
                        color: Colors.white),
//                    height: 60,
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 15),
                        width: 45,
                        height: 6,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                            color: CIRCLE_AVATAR_COLOR),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        LocaleKeys.global_choose.tr(),
                        style: TextStyle(
                            color: BORDER_COLOR,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 14, left: 14, bottom: 12),
                    width: MediaQuery.of(context).size.width,
                    child: HittapaOutline(
                      child: GestureDetector(
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/geopin-outline.svg',
                              color: BORDER_COLOR,
                            ),
                            SizedBox(
                              width: 14,
                            ),
                            Expanded(
                              child: Text(
                                selectedAddress == null
                                    ? LocaleKeys.global_loading.tr()
                                    : selectedAddress.addressLine,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: NAVIGATION_NORMAL_TEXT_COLOR),
                              ),
                            ),
                            SvgPicture.asset('assets/arrow-forward-outline.svg')
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pop(selectedAddress);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
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
    final coordinates = Coordinates(lat, lon);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      selectedAddress = addresses.first;
    });
  }
}
