import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:hittapa/config.dart';


class PlaceBloc with ChangeNotifier {

  Future<List> search(String query) async {
    String url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=${MapConfig.googleMapKey}&language=${MapConfig.language}&region=${MapConfig.countryCode}&types=geocode";
    Response response = await Dio().get(url);
    return response.data['predictions'];
  }

  Future<List> searchStreet(String query) async {
    String url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=${MapConfig.googleMapKey}&language=${MapConfig.language}&region=${MapConfig.countryCode}&types=address";
    Response response = await Dio().get(url);
    return response.data['predictions'];
  }


  @override
  void dispose() {
    super.dispose();
  }
}