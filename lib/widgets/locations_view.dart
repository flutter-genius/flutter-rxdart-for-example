import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/services/cloud_firestore_service.dart';
import 'package:hittapa/widgets/hittapa_outline.dart';
import 'package:hittapa/global_export.dart';

//ignore: must_be_immutable
class LocationsView extends StatefulWidget {
  final Address currentAddress;
  final FirebaseId userId;
  String addressLine;

  LocationsView({this.currentAddress, this.userId, this.addressLine});

  @override
  _LocationsViewState createState() => _LocationsViewState();
}

class _LocationsViewState extends State<LocationsView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: <Widget>[
          widget.currentAddress !=null ? Container(
            child: Column(
              children: [
                Container(
                  child: Text(
                    LocaleKeys.widget_selected_location.tr(),
                    style: TextStyle(color: BORDER_COLOR, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  child: HittapaOutline(
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
                            widget.currentAddress != null
                                ? '${widget.addressLine},'
                                : '',
                            style: TextStyle(
                                fontSize: 12, color: NAVIGATION_NORMAL_TEXT_COLOR),
                            softWrap: false,
                          ),
                        ),
                        SvgPicture.asset('assets/arrow-forward-outline.svg')
                      ],
                    ),
                  ),
                  onTap: () {                    
                    FirebaseFirestore.instance.collection(FB.USERS_COLLECTION).doc(widget.userId.toString())
                        .collection('saved_locations').where('addressLine', isEqualTo: widget.addressLine)
                        .snapshots().listen((value) {
                          print('@@@@@ firebase firestore get snapshots data value');
                          print(value);
                      if (value == null) {
                        FirebaseFirestore.instance.collection(FB.USERS_COLLECTION).doc(widget.userId.toString())
                            .collection('saved_locations').add({...Map<String, dynamic>.from(widget.currentAddress.toMap()), "addressLine": widget.addressLine});
                      }
                    });
                    var data = {
                      'address' : widget.currentAddress,
                      'addressLine' : widget.addressLine,
                    };
                    Navigator.of(context).pop(data);
                  },
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ) : Container(),
          Container(
            child: Text(
              LocaleKeys.widget_previously_used_locations.tr(),
              style: TextStyle(color: BORDER_COLOR, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection(FB.USERS_COLLECTION).doc(widget.userId.toString())
                  .collection('saved_locations').snapshots(),
              builder: (context, snap) {
                switch (snap.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  default:
                    return ListView.builder(
                      itemCount: (snap.data.docs ?? []).length,
                      itemBuilder: (context, index) {
                        Address _address = Address.fromMap(snap.data.docs[index].data());
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 7),
                          child: GestureDetector(
                            child: HittapaOutline(
                              child: Row(
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/time_outline.svg',
                                    color: BORDER_COLOR,
                                  ),
                                  SizedBox(
                                    width: 14,
                                  ),
                                  Expanded(
                                    child: Text(
                                      _address.addressLine,
                                      softWrap: true,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: NAVIGATION_NORMAL_TEXT_COLOR),
                                    ),
                                  ),
                                  SvgPicture.asset(
                                      'assets/arrow-forward-outline.svg')
                                ],
                              ),
                            ),
                            onTap: (){
                              var data = {
                                'address' : _address,
                                'addressLine' : _address.addressLine,
                              };
                              Navigator.of(context).pop(data);
                            }
                          ),
                        );
                      },
                    );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
