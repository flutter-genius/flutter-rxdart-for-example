import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/location.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/widgets/place_search.dart';
import 'package:hittapa/widgets/round_button.dart';
import 'package:hittapa/widgets/show_confirm_dialog.dart';
import 'package:hittapa/global_export.dart';
import 'package:hittapa/actions/actions.dart';
import 'package:hittapa/models/models.dart';

final kGoogleApiKey = "AIzaSyBE-5QgYsnFaBUSUR8LL7f-IETuPc29frs";

class SearchLocationScreen extends PlacesAutocompleteWidget {
  final double latitude;
  final double longitude;
  final LocationModel address;
  SearchLocationScreen({this.latitude, this.longitude, this.address})
      : super(
          apiKey: 'AIzaSyCjpgBMTPJhCEw6Yi0kP_8ECx4LMR0ZbCc',
          sessionToken: Uuid().generateV4(),
          language: "sw",
          components: [],
        );

  @override
  _SearchLocationScreenState createState() => _SearchLocationScreenState(latitude: latitude, longitude: longitude, address: address);
}

class _SearchLocationScreenState extends PlacesAutocompleteState {
  final double latitude;
  final double longitude;
  final LocationModel address;
  _SearchLocationScreenState({this.latitude, this.longitude, this.address});
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final searchScaffoldKey = GlobalKey<ScaffoldState>();
  Address selectedAddress;
  GoogleMapsPlaces _places;
  GoogleMapController mapController;
  bool _isListExpended = false;
  Timer _timer, _timer_4;

  @override
  void initState() {
    super.initState();
    _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

    if(latitude==0 && longitude==0 && address==null) {
      Geolocator.getCurrentPosition().then((value) {
        refresh(value.latitude, value.longitude);
        markPlace(value.latitude, value.longitude);
        GeoLocationModel geoLocationData = new GeoLocationModel(geoLatitude: value.latitude, geoLongitude: value.longitude);
        SetGeoLocationData(geoLocationData);
      });
    } else {


      _timer = Timer(Duration(seconds: 2), () {
        refresh(latitude, longitude);
        markPlace(latitude, longitude);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer_4 != null) {
      _timer_4.cancel();
    }
    if (_timer != null) {
      _timer.cancel();
    }
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
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onTap: (value) {
              markPlace(value.latitude, value.longitude);
            },
            onMapCreated: _onCreateMap,
            initialCameraPosition: CameraPosition(target: LatLng(0.0, 0.0), zoom: 11),
            markers: Set<Marker>.of(markers.values),
          ),
          SafeArea(
            child: Container(
              height: 50,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              margin: EdgeInsets.only(right: 14, top: 12, left: 50),
              child: AppBarPlacesAutoCompleteTextField(
                hintText: 'Search your meeting point address',
                onChanged: () {
                  setState(() {
                    _isListExpended = true;
                  });
                },
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
          SafeArea(
            child: Container(
              margin: EdgeInsets.only(right: 14, top: 15, left: 5),
              child: IconButton(
                icon: SvgPicture.asset('assets/arrow-back.svg'),
                onPressed: () => Navigator.of(context).pop(),
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
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;

      refresh(lat, lng);
      markPlace(lat, lng);
      _timer_4 = Timer(Duration(seconds: 4), () => onSelectLocation(lat, lng));
    }
  }

  // google map initializer
  _onCreateMap(GoogleMapController controller) async {
    mapController = controller;
  }

  // google map refresher
  void refresh(double latitude, double longitude) async {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude), zoom: 15.0)));
  }

  // set place mark on google map
  markPlace(double lat, double lng) {
    final String markerIdVal = 'marker_id_hittapa';
    final MarkerId markerId = MarkerId(markerIdVal);
    bitmapDescriptorFromSvgAsset(context, 'assets/hittapa_logo.svg')
        .then((value) {
      final Marker marker = Marker(
          markerId: markerId,
          position: LatLng(lat, lng,),
          infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
          icon: value);
      setState(() {
        markers[markerId] = marker;
      });
    });
  }

  // show success dialog function
  showSuccessDialog() async {
    await showDialog(context: context, useSafeArea: false, builder: (context) => ConfirmDialog(
        title: Center(child: Text(LocaleKeys.event_search_result.tr(), style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold))),
        firstButton: Container(
          width: 170,
          child: HittapaRoundButton(
            isPopUp: true,
            isGoogleColor: true,
            text: LocaleKeys.global_ok.tr(),
            onClick: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        icon: Container(),
        yourWidget: Container(
          child: Text(
              LocaleKeys.event_all_search.tr(), style: TextStyle(fontSize: 17, color: Colors.white)),
        )
    ));
  }

  // select location request
  onSelectLocation(double lat, double lng) {
    navigateToLocationSearchResultScreen(context, lat, lng);
  }
}
