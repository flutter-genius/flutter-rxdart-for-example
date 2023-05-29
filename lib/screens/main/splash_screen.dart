import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/actions/actions.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/models/appState.dart';
import '../../config.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hittapa/utils/routes.dart';


// ignore: must_be_immutable
class SplashScreen extends StatelessWidget {
  GeoLocationModel geoLocationData = new GeoLocationModel(geoLatitude: 57.7089, geoLongitude: 11.9746);
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: (store) => store,
      onInit: (store){
        try {
          Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest).then((position) {
              geoLocationData = new GeoLocationModel(geoLatitude: position.latitude, geoLongitude: position.longitude);
              store.dispatch(SetGeoLocationData(geoLocationData));
              Navigator.pushNamedAndRemoveUntil(context, Routes.MAIN, (Route<dynamic> route) => false);
          });
        } catch (e) {
          print(e);
          Navigator.pushNamedAndRemoveUntil(context, Routes.MAIN, (Route<dynamic> route) => false);          
        }          
      },
      builder: (context, store) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/hittapa_logo.svg',
                    width: 54,
                    height: 67,
                  )
                ],
              ),
              const SizedBox(
                height: 9,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    appTitle,
                    style: TextStyle(
                        color: TITLE_TEXT_COLOR,
                        fontSize: 21,
                        fontWeight: FontWeight.w600),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
