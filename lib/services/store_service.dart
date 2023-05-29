import 'dart:convert';

import 'package:geocoder/geocoder.dart';
import 'package:hittapa/models/filter.dart';
import 'package:shared_preferences/shared_preferences.dart';

saveToken(String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', value);
}

Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

saveAddress(Address value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> result = prefs.getStringList('address') ?? [];
  result.add(jsonEncode(value.toMap()));
  await prefs.setStringList('address', result);
}

Future<List<Address>> getAddressed() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<Address> result = [];

  if (prefs.getStringList('address') != null) {
    prefs
        .getStringList('address')
        .forEach((element) => result.add(Address.fromMap(jsonDecode(element))));
  }
  return result;
}

saveFilters(FilterModel value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (value == null) {
    await prefs.setString('filters', null);
  } else {
    String json = jsonEncode(value.toMap());
    await prefs.setString('filters', json);
  }
}

Future<FilterModel> getFilters() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return FilterModel.map(jsonDecode(prefs.getString('filters') ?? '{}'));
}
