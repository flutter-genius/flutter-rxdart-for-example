import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:hittapa/config.dart';
import 'package:hittapa/models/event.dart';
import 'package:hittapa/services/cloud_firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/widgets/locations_view.dart';
import 'package:hittapa/theme.dart';
import 'package:hittapa/services/addressService.dart';
import 'package:hittapa/global_export.dart';

class MapScreen extends StatefulWidget {
  final EventModel event;
  final String userId;

  MapScreen({this.event, this.userId});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  Address selectedAddress;
  SolidController _controller = SolidController();
  bool _isLoading = false, _isNumberSearch = false;
  TextEditingController _queryController = new TextEditingController();
  TextEditingController _numberController = new TextEditingController();
  String _queryText, _numberText;
  List<dynamic> _searchResult = [];
  GoogleMapsPlaces _places;
  String currentAddressLine;
  String currentId;

  PlaceBloc _placeBloc = new PlaceBloc();

  FocusNode focusNode;

  void setFocus() async{
    await Future.delayed(Duration(milliseconds: 200));
    FocusScope.of(context).requestFocus(focusNode);
  }


  @override
  void initState() {
    super.initState();
    focusNode = new FocusNode();

    // listen to focus changes
    focusNode.addListener(() => print('focusNode updated: hasFocus: ${focusNode.hasFocus}'));
    _places = GoogleMapsPlaces(apiKey: MapConfig.kGoogleApiKey);
    Timer(Duration(seconds: 1), () => _controller.show());
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: AppTheme.whiteBackgroundColor
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 17, right: 17, left: 7),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      icon: SvgPicture.asset('assets/arrow-back.svg'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                        child: Column(
                          children: [
                            _isNumberSearch ? Row(
                              children: <Widget>[
                                Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width - 200,
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
                                    BorderRadius.all(Radius.circular(20)),
                                    border: Border.all(color: Colors.grey, width: 1)
                                  ),
                                  child: TextField(
                                    controller: _queryController,
                                    decoration: new InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 15, right: 10),
                                      hintText: widget.event!=null && widget.event.location != null && widget.event.location.address != null ? '${widget.event.location.address}' : 'Search your meeting point address',
                                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                    ),
                                    keyboardType: TextInputType.text,
                                    onChanged: (value) async{
                                      _isNumberSearch = false;
                                      _numberController.text = null;
                                      _controller.hide();
                                      if(value.length < 3){
                                      setState(() {
                                        _searchResult = [];
                                      });
                                        return null;
                                      }
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      _searchResult = await _placeBloc.search(value.toString());
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width: 15),
                                Container(
                                  height: 50,
                                  width: 100,
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
                                    BorderRadius.all(Radius.circular(20)),
                                    border: Border.all(color: Colors.grey, width: 1)
                                  ),
                                  child: TextField(
                                    controller: _numberController,
                                    focusNode: focusNode,
                                    decoration: new InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 15, right: 10),
                                      hintText: _numberText != null ? _numberText : LocaleKeys.global_number.tr(),
                                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                    ),
                                    keyboardType: TextInputType.phone,
                                    autofocus: true,
                                    onChanged: (value) async{
                                      print(value);
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      var _query = _queryText != null ? _queryText + ' ' + value : value;
                                      _searchResult = await _placeBloc.searchStreet(_query.toString());
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    },
                                  ),
                                )
                              ]
                            ) : Container(
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
                                BorderRadius.all(Radius.circular(20)),
                                border: Border.all(color: Colors.grey, width: 1)
                              ),
                              child: TextField(
                                controller: _queryController,
                                decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 15, right: 10),
                                  hintText: widget.event!=null && widget.event.location != null && widget.event.location.address != null ? '${widget.event.location.address}' : 'Search your meeting point address',
                                  hintStyle: TextStyle(fontSize: 17, color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                ),
                                keyboardType: TextInputType.text,
                                onChanged: (value) async{
                                  _isNumberSearch = false;
                                  _numberController.text = null;
                                  _controller.hide();
                                  if(value.length < 3){
                                   setState(() {
                                     _searchResult = [];
                                   });
                                    return null;
                                  }
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  _searchResult = await _placeBloc.search(value.toString());
                                  setState(() {
                                    _isLoading = false;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 10,),
                            _isNumberSearch ? Container(
                              height: 32,
                              width: 200,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [GOOGLE_COLOR, BORDER_COLOR]
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                              ),
                              alignment: Alignment.center,
                              child: FlatButton(
                                child: Text( LocaleKeys.create_location_continue_without_number.tr(), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFFF7F7F7)),),
                                onPressed: (){
                                  FocusScope.of(context).requestFocus(new FocusNode());
                                  displayPrediction(currentId);
                                },
                              ),
                            ) : Container()
                          ],
                        )
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: _isNumberSearch ? 160 : 100, right: 17, left: 17),
            child: bodyWidget(context),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 0.1),
          color: Colors.white,
        ),
        child: SolidBottomSheet(
          controller: _controller,
          maxHeight: MediaQuery.of(context).size.height*0.4,
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
            addressLine: currentAddressLine,
          ),
        ),
      ),
    );
  }

  Widget bodyWidget(BuildContext context){
    return Container(
      child: _isLoading
          ? _Loader()
          : _searchResult==null || _searchResult.length ==0 ? Container() : ListView(
        children: _searchResult.map((p) => Container(
          color: Colors.white,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width-150,
                  child: Text(p['description'], style: TextStyle(fontSize: 17, color: Colors.black87),),
                ),
                Container(
                  height: 36,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [GOOGLE_COLOR, BORDER_COLOR]
                      ),
                      borderRadius: BorderRadius.circular(24),
                  ),
                  child: FlatButton(
                    child: Text( LocaleKeys.global_choose.tr(), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Color(0xFFF7F7F7)),),
                    onPressed: (){
                      currentId = p['place_id'];
                      if(_isNumberSearch){
                        _searchResult = [];
                        FocusScope.of(context).requestFocus(new FocusNode());
                        currentAddressLine = p['description'];
                        displayPrediction(p['place_id']);
                      } else {
                        _isNumberSearch = true;
                        _queryText = p['structured_formatting']['main_text'];
                        _queryController.text = p['description'];
                        currentAddressLine = p['description'];
                        setState(() {});
                        setFocus();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        )).toList(),
      ),
    );
  }

  Future<Null> displayPrediction(String placeId) async {
    if (placeId != null) {
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;
      final coordinates =new Coordinates(lat, lng);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      setState(() {
        selectedAddress = addresses.first;
      });
      FirebaseFirestore.instance.collection(FB.USERS_COLLECTION).doc(widget.userId.toString())
          .collection('saved_locations').where('addressLine', isEqualTo: currentAddressLine)
          .snapshots().listen((value) {
        if (value.docs.isEmpty) {
          FirebaseFirestore.instance.collection(FB.USERS_COLLECTION).doc(widget.userId.toString())
              .collection('saved_locations').add({...Map<String, dynamic>.from(selectedAddress.toMap()), "addressLine": currentAddressLine});
        }
      });
      var data = {
        'address' : selectedAddress,
        'addressLine' : currentAddressLine,
      };
      Navigator.of(context).pop(data);
    }
  }

}

class _Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxHeight: 3.0),
        child: LinearProgressIndicator());
  }
}
