import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/global_export.dart';
import 'package:hittapa/models/models.dart';
import 'package:map_launcher/map_launcher.dart';

import '../../config.dart';

class CheckLocationsScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final bool isAccepted;
  final String name;
  final String address;
  final EventModel event;

  CheckLocationsScreen(
      {this.latitude,
      this.longitude,
      this.isAccepted,
      this.name,
      this.address,
      this.event
      });

  @override
  _CheckLocationsScreenState createState() => _CheckLocationsScreenState();
}

class _CheckLocationsScreenState extends State<CheckLocationsScreen> {
  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  double screenWidth = 0.0;

  @override
  void initState() {
    super.initState();
    final int markerCount = markers.length;

    if (markerCount == 12) {
      return;
    }

    final String markerIdVal = 'marker_id_hittapa';
    final MarkerId markerId = MarkerId(markerIdVal);
    _bitmapDescriptorFromSvgAsset(
            context,
            widget.isAccepted
                ? 'assets/hittapa_logo.svg'
                : 'assets/approximate_place.svg')
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            scrollGesturesEnabled: true,
            onMapCreated: _onCreateMap,
            zoomGesturesEnabled: false,
            zoomControlsEnabled: false,
            rotateGesturesEnabled: true,
            tiltGesturesEnabled: true,
            initialCameraPosition: CameraPosition(
                target: LatLng(widget.latitude, widget.longitude), zoom: 15.0),
            markers: Set<Marker>.of(markers.values),
          ),
          Container(
            height: 75,
            padding: EdgeInsets.only(top: 15),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Stack(
              children: [
                // Center(
                //   child: Text(
                //     widget.name != '' ? widget.name.length < 20 ? widget.name : widget.name.substring(0, 19) + ' ...' : '',
                //     style: TextStyle(
                //         color: TITLE_TEXT_COLOR,
                //         fontWeight: FontWeight.w600,
                //         fontSize: 21),
                //   ),
                // ),
                Positioned(
                  top: 10,
                  left: 0,
                  child: IconButton(
                    icon: SvgPicture.asset('assets/arrow-back.svg', color: BORDER_COLOR),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),          
          Positioned(
            bottom: 40,
            left: 30,
            child: Container(
              // height: 100,
              width: MediaQuery.of(context).size.width-60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      width: 100,
                      height: 100,
                      child: GFAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          widget.event.imageUrl
                        ),
                        shape: GFAvatarShape.standard
                      ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width - 180,
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                          '${widget.event.name}',
                          style: TextStyle(
                            fontSize: 17,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${widget.event.isFlexibleDate ? 'Any date' : ''} '
                            '${DateFormat('${widget.event.isFlexibleDate ? '' : 'd MMM, '}'
                            '${widget.event.isFlexibleStartTime ? '' : 'HH:mm'}').format(widget.event.startDT)} - '
                            '${(widget.event.isFlexibleDate && widget.event.isFlexibleStartTime) ? ' and time' : widget.event.isFlexibleStartTime ? 'Any time' : ''}'
                            '${widget.event.isFlexibleDate ? 'Any date' : ''} '
                            '${DateFormat('${widget.event.isFlexibleDate ? '' : ''}'
                            '${widget.event.isFlexibleEndTime ? '' : 'HH:mm'}').format(widget.event.endDT)}'
                            '${(widget.event.isFlexibleDate && widget.event.isFlexibleEndTime) ? ' and time' : widget.event.isFlexibleEndTime ? 'Any time' : ''}',
                          style: TextStyle(
                            color: GOOGLE_COLOR,
                            fontSize: 13
                          )
                        ),
                        SizedBox(height: 5,),
                        widget.isAccepted ? GestureDetector(
                          onTap: () async {
                            final availableMaps = await MapLauncher.installedMaps;
                            if (debug)
                              print(
                                  availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

                            await availableMaps.first.showMarker(
                              coords: Coords(widget.latitude, widget.longitude),
                              title: widget.name,
                              description: widget.address,
                            );
                          },
                          child: Text(
                            widget.address,
                            style: TextStyle(
                                color: GOOGLE_COLOR,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                        ) : Container(),
                      ]
                    )
                  ),
                ]
              ),
            )
          ),
        ],
      ),
    );
  }

  // google map initializer
  _onCreateMap(GoogleMapController controller) async {
    mapController = controller;
    refresh();
  }

  // google map refresher
  void refresh() async {
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng((widget.latitude + (widget.isAccepted ? 0 : 0.0025)),
            (widget.longitude)),
        zoom: 15.0)));
  }

  // convert Svg file to Bitmap function
  Future<BitmapDescriptor> _bitmapDescriptorFromSvgAsset(BuildContext context, String assetName) async {
    String svgString = await DefaultAssetBundle.of(context).loadString(assetName);
    DrawableRoot drawableRoot = await svg.fromSvgString(svgString, null);
    ui.Picture picture = drawableRoot.toPicture(size: widget.isAccepted ? Size(152, 192) : Size(608, 768));
    ui.Image image = await picture.toImage(widget.isAccepted ? 152 : 608, widget.isAccepted ? 192 : 768);
    ByteData bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
  }
}
