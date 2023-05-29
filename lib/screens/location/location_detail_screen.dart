import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/models/event.dart';
import 'package:hittapa/models/location_category.dart';
import 'package:hittapa/models/open_day_time.dart';
import 'package:hittapa/models/venue.dart';
import 'package:hittapa/widgets/event_list_tile.dart';
import 'package:hittapa/widgets/location_bottom_widget.dart';
import 'package:hittapa/widgets/location_timetable_widget.dart';
import 'package:hittapa/widgets/round_button.dart';
import 'package:kenburns/kenburns.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:hittapa/global_export.dart';

import 'package:hittapa/services/node_service.dart';

class LocationDetailScreen extends StatefulWidget {
  final VenueModel location;
  final List<File> images;
  final File logo;
  final List<LocationCategoryModel> categories;
  final List<VenueOpenTimesModel> openTimes;

  LocationDetailScreen(
      {this.location, this.images, this.logo, this.openTimes, this.categories});

  @override
  _LocationDetailScreenState createState() => _LocationDetailScreenState();
}

class _LocationDetailScreenState extends State<LocationDetailScreen> {
  bool isLoading = false;
  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  VenueModel _location;
  final controller = PageController(keepPage: true);
  List<EventModel> events = [];

  _loadLocationEvents() async {
    var _result = await NodeService().getEventsByLocation(_location.id);
    setState(() {
      if(_result != null && _result['data'] != null) {
        for(int i=0; i<_result['data'].length; i++){
          EventModel _event = EventModel.fromJson(_result['data'][i]);
          events.add(_event);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _location = widget.location;
    final int markerCount = markers.length;

    if (markerCount == 12) {
      return;
    }
    final String markerIdVal = 'marker_id_hittapa_location';
    final MarkerId markerId = MarkerId(markerIdVal);
    bitmapDescriptorFromSvgAsset(context, 'assets/hittapa_logo.svg')
        .then((value) {
      final Marker marker = Marker(
          markerId: markerId,
          position: LatLng(
            widget.location.location.coordinates[0],
            widget.location.location.coordinates[1],
          ),
          infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
          icon: value);
      setState(() {
        markers[markerId] = marker;
      });
      // loadCategories();
    });
    _loadLocationEvents();
  }

  // auto swipe function image page view
  pageSwipe() {
    Timer(Duration(seconds: 3), () {
      if (controller.page < (_location.imageUrls ?? []).length - 1) {
        controller
            .nextPage(
                duration: Duration(milliseconds: 700), curve: Curves.linear)
            .then((value) => pageSwipe());
      } else {
        controller
            .animateToPage(0,
                duration: Duration(milliseconds: 700), curve: Curves.linear)
            .then((value) => pageSwipe());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return  StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        builder: (context, store) {
          AppState state = store.state;
          var user = state.user;
          return Scaffold(
            backgroundColor: Colors.white,
            body: ModalProgressHUD(
              inAsyncCall: isLoading,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width + 50,
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  height: MediaQuery.of(context).size.width,
                                  child: PageView(
                                      controller: controller,
                                      children: _location.id.isEmpty
                                          ? widget.images
                                          .map((e) => Container(
                                        child: Image.file(
                                          e,
                                          fit: BoxFit.cover,
                                        ),
                                      ))
                                          .toList()
                                          : (_location.imageUrls ?? [_location.image])
                                          .map((e) => KenBurns(
                                        maxScale: 2.0,
                                        minAnimationDuration:
                                        Duration(milliseconds: 3000),
                                        child: Hero(
                                          tag:
                                          'location_hero_${_location.id}',
                                          child: CachedNetworkImage(
                                            imageUrl:
                                            e ?? '',
                                            placeholder: (context, url) =>
                                                Center(
                                                  child: Icon(Icons.image),
                                                ),
                                            errorWidget:
                                                (context, url, err) =>
                                                Center(
                                                  child: Icon(
                                                      Icons.broken_image),
                                                ),
                                            fit: BoxFit.cover,
                                            height: MediaQuery.of(context)
                                                .size
                                                .width,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                        ),
                                      ))
                                          .toList()),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: LOCATION_LABEL_BACKGROUND_COLOR,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20))),
                                    width: MediaQuery.of(context).size.width - 14,
                                    child: Row(
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              width: 60,
                                              height: 60,
                                              margin: const EdgeInsets.only(
                                                  left: 15, right: 8),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30)),
                                                child: _location.id.isEmpty
                                                    ? Image.file(widget.logo,
                                                    fit: BoxFit.cover)
                                                    : CachedNetworkImage(
                                                  imageUrl: _location.logo ?? DEFAULT_AVATAR,
                                                  placeholder: (context, url) =>
                                                      Center(
                                                        child:
                                                        CircularProgressIndicator(),
                                                      ),
                                                  errorWidget:
                                                      (context, url, err) =>
                                                      Center(
                                                        child: Icon(
                                                            Icons.error_outline),
                                                      ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                _location.name,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color:
                                                    NAVIGATION_NORMAL_TEXT_COLOR,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                getEventCategoriesString(
                                                    _location.id.isEmpty
                                                        ? widget.categories
                                                        : _location.eventCategories),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: BORDER_COLOR,
                                                    fontWeight: FontWeight.w600),
                                              )
                                            ],
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              (_location.point ?? 0.0).toStringAsFixed(1) ?? '',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                  NAVIGATION_NORMAL_TEXT_COLOR),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                RatingBarIndicator(
                                                  rating: _location.point ?? 0.0,
                                                  itemBuilder: (context, index) =>
                                                      Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                  itemCount: 5,
                                                  itemSize: 10.0,
                                                ),
                                                SizedBox(
                                                  width: 6,
                                                ),
                                                Text(
                                                  '(${_location.reviews.toString()})',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: BORDER_COLOR,
                                                      fontWeight: FontWeight.w600),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 10,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 14),
                            child: Row(
                              children: <Widget>[
                                SvgPicture.asset('assets/time_outline.svg', width: 20,),
                                SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  LocaleKeys.location_detail_opening_hours.tr(),
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: BORDER_COLOR),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 36, right: 14),
                            child: _location.is24Opened
                                ? Text(
                               LocaleKeys.create_location_open_all.tr(),
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: TITLE_TEXT_COLOR),
                            )
                                : LocationTimeTableWidget(
                              openTimes: (_location.id.isEmpty
                                  ? widget.openTimes
                                  : _location.openTimes),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SvgPicture.asset('assets/telephone.svg'),
                                SizedBox(
                                  width: 6,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                       LocaleKeys.location_detail_telephone.tr(),
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: BORDER_COLOR),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      _location.phoneNumber,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: NAVIGATION_NORMAL_TEXT_COLOR),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SvgPicture.asset('assets/telephone.svg'),
                                SizedBox(
                                  width: 6,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                       LocaleKeys.location_detail_website.tr(),
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: BORDER_COLOR),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      _location.websiteUrl,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: NAVIGATION_NORMAL_TEXT_COLOR),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 25),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              child: Container(
                                color: BACKGROUND_COLOR,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 120,
                                      height: 100,
                                      child: GoogleMap(
                                        scrollGesturesEnabled: false,
                                        onMapCreated: _onCreateMap,
                                        initialCameraPosition: CameraPosition(
                                            target: LatLng(
                                                _location
                                                    .location.coordinates[0],
                                                _location
                                                    .location.coordinates[1]),
                                            zoom: 11),
                                        markers: Set<Marker>.of(markers.values),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Text(
                                        _location.location.address,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: NAVIGATION_NORMAL_TEXT_COLOR,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    SvgPicture.asset('assets/map_directions.svg')
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: 14,
                              right: 14,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                   LocaleKeys.location_detail_description.tr(),
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: NAVIGATION_NORMAL_TEXT_COLOR,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  _location.desc ?? '',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: BORDER_COLOR,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                          widget.location.ownerId == user.uid ? Container(
                            margin: EdgeInsets.only(left: 14, right: 14, top: 25),
                            child: Text(
                               LocaleKeys.global_events.tr(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                  color: NAVIGATION_NORMAL_TEXT_COLOR),
                            ),
                          ) : Container(),
                          widget.location.ownerId == user.uid ? Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 14),
                              child: Builder(
                                  builder: (context) {
                                    return Column(
                                      children: (events ?? [])
                                          .map((e) => EventListTile(e))
                                          .toList(),
                                    );
                                  })) : Container(),
                          SizedBox(
                            height: 100,
                          )
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Container(
                      height: 50,
                      child: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _location.id.isEmpty
                        ? Container(
                      height: 80,
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: const Color(0xFF696969),
                            spreadRadius: -10,
                            blurRadius: 30,
                          ),
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: HittapaRoundButton(
                              text:  LocaleKeys.global_preview_edit.tr().toUpperCase(),
                              isNormal: true,
                              onClick: () => Navigator.of(context).pop(),
                            ),
                          ),
                          Expanded(
                            child: HittapaRoundButton(
                              text: LocaleKeys.global_publish.tr().toUpperCase(),
                              // onClick: onPublish,
                            ),
                          )
                        ],
                      ),
                    )
                        : LocationBottomWidget(
                      location: _location,
                      user: user,
                      events: events,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  // google map initializer
  _onCreateMap(GoogleMapController controller) async {
    mapController = controller;
    refresh();
  }

  // google map refresher
  void refresh() async {
    mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(_location.location.coordinates[0],
            _location.location.coordinates[1]),
        zoom: 15.0)));
  }
}
