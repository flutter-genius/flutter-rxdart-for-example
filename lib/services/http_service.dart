 import 'dart:async';
 import 'dart:convert';

 import 'package:hittapa/global.dart';
 import 'package:http/http.dart' as http;
 import 'dart:io';

 // check internet
 Future<bool> checkInternet() async {
   try {
     final result = await InternetAddress.lookup('google.com');
     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
       print('connected');
       return true;
     } else {
       return false;
     }
   } on SocketException catch (_) {
     print('not connected');
     return false;
   }
 }

 Future<dynamic> requestAuthPost(String url, dynamic body, String token) async {
   Map<String, String> header = {
     'x-access-token': '${token ?? ''}',
     'Content-Type': 'application/json',
   };

   String _body = json.encode(body);

   print(BASE_ENDPOINT + url);

   final response =
       await http.post(Uri.parse(BASE_ENDPOINT + url), headers: header, body: _body);

   if (response.statusCode >= 200 && response.statusCode < 300) {
     return json.decode(utf8.decode(response.bodyBytes));
   } else {
     return null;
   }
 }

 // get
 Future<dynamic> requestUnAuthGet(String url) async {
   Map<String, String> header = {
     'Content-Type': 'application/json',
   };

   print(BASE_ENDPOINT + url);

   final response = await http.get(Uri.parse(BASE_ENDPOINT + url), headers: header);

   if (response.statusCode >= 200 && response.statusCode < 300) {
     return json.decode(utf8.decode(response.bodyBytes));
   } else {
     return null;
   }
 }

 // post
 Future<dynamic> requestUnAuthPost(String url, dynamic body) async {
   Map<String, String> header = {
     'Content-Type': 'application/json',
   };

   String _body = json.encode(body);
   print(BASE_ENDPOINT + url);

   final response =
       await http.post(Uri.parse(BASE_ENDPOINT + url), headers: header, body: _body);

   if (response.statusCode >= 200 && response.statusCode < 300) {
     return json.decode(utf8.decode(response.bodyBytes));
   } else {
     return null;
   }
 }

 // patch
 Future<dynamic> requestPatch(String url, dynamic body, String param) async {
   Map<String, String> header = {
     'Content-Type': 'application/json',
   };

   String _body = json.encode(body);
   print(BASE_ENDPOINT + url + '/' + param);

   final response =
   await http.patch(Uri.parse(BASE_ENDPOINT + url + '/' + param), headers: header, body: _body);

   if (response.statusCode >= 200 && response.statusCode < 300) {
     return json.decode(utf8.decode(response.bodyBytes));
   } else {
     return null;
   }
 }

 /// auth patch
 Future<dynamic> requestAuthPatch(String url, dynamic body, String param, String token) async {
   Map<String, String> header = {
     'x-access-token': '${token ?? ''}',
     'Content-Type': 'application/json',
   };

   String _body = json.encode(body);
   print(BASE_ENDPOINT + url + '/' + param);

   final response = await http.patch(Uri.parse(BASE_ENDPOINT + url + '/' + param), headers: header, body: _body);

   if (response.statusCode >= 200 && response.statusCode < 300) {
     // If the call to the server was successful, parse the JSON
     return json.decode(utf8.decode(response.bodyBytes));
   } else {
     // If that call was not successful, throw an error.
     return null;
   }
 }

 Future<dynamic> requestAuthGet(String url, String id, String token) async {
   Map<String, String> header = {
     'x-access-token': '${token ?? ''}',
     'Content-Type': 'application/json',
   };
   print(BASE_ENDPOINT + url + '/' + id);
   String _url = id==null ? BASE_ENDPOINT + url : BASE_ENDPOINT + url + '/' + id;
   final response = await http.get(
     Uri.parse(_url),
     headers: header,
   );
   if (response.statusCode >= 200 && response.statusCode < 300) {
     // If the call to the server was successful, parse the JSON
     return json.decode(utf8.decode(response.bodyBytes));
   } else {
     // If that call was not successful, throw an error.
     return null;
   }
 }


  Future<dynamic> requestGet() async {
    Map<String, String> header = {};
    final response = await http.get(
      Uri.parse("https://2019ncov.asia/api/country_region"),
      headers: header,
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // If the call to the server was successful, parse the JSON
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      // If that call was not successful, throw an error.
      return null;
    }
  }