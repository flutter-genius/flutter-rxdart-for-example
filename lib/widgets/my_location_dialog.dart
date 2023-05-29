import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:hittapa/actions/actions.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/widgets/round_button.dart';
import 'package:hittapa/global_export.dart';

//ignore: must_be_immutable
class MyLocationDialog extends StatelessWidget {
  String _selected = '';
  final AnimationController controller;
  final BuildContext context;

  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;

  MyLocationDialog({this.controller, this.context});

  List<LocationModel> _locations = [];

  void initState() {
    _drawerContentsOpacity = CurvedAnimation(
      parent: ReverseAnimation(controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    ));
  }

  void dispose() {
    controller.dispose();
  }

  startTime() async {
    var _duration = Duration(milliseconds: 200);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pop(this.context);
  }

  dismissDialog() {
    controller.reverse();
    startTime();
  }

  showLocationDialog(BuildContext context) {
    if (controller == null ||
        _drawerDetailsPosition == null ||
        _drawerContentsOpacity == null) {
      return;
    }
    controller.forward();
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) => SlideTransition(
        position: _drawerDetailsPosition,
        child: FadeTransition(
          opacity: ReverseAnimation(_drawerContentsOpacity),
          child: this,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        builder: (context, store){
          List<String> _addresses = [];
          FilterModel _filter = store.state.eventFilter;
          Function dispatch = store.dispatch;
          UserModel _user = store.state.user;
          _locations = _user.savedLocations;
          for(int i=0; i<_locations.length; i++) {
            if (_locations[i] != null && _locations[i].address != null) {
              _addresses.add(_locations[i].address);
            }
          }
          return Opacity(
            opacity: 1.0,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: SizedBox(),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40)),
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 36,
                        ),
                        Text(
                          LocaleKeys.widget_use_my_saved_locations.tr(),
                          style: TextStyle(
                              fontSize: 17,
                              color: NAVIGATION_NORMAL_TEXT_COLOR,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 150,
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return SingleChildScrollView(
                                child: RadioButtonGroup(
                                  labelStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                  orientation:
                                  GroupedButtonsOrientation.VERTICAL,
                                  activeColor: GRADIENT_COLOR_ONE,
                                  labels: (_addresses ?? [])
                                      .map((e) => e)
                                      .toList(),
                                  picked: _selected,
                                  onSelected: (String value) {
                                    setState(() {
                                      _selected = value;
                                    });
                                  },
                                  itemBuilder: (Radio rb, Text txt, int i) {
                                    return Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 12),
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: rb,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            child: txt,
                                          ),
                                          GFIconButton(
                                            color: Colors.white,
                                            icon: SvgPicture.asset(
                                                'assets/arrow-forward-outline.svg'),
                                            onPressed: () {
                                              navigateToSearchLocationScreen(
                                                  context, store.state.user.saved_locations[i].coordinates[0], store.state.user.saved_locations[i].coordinates[1], store.state.user.saved_locations[i]);
                                            },
                                            shape: GFIconButtonShape.pills,
                                            boxShadow: BoxShadow(
                                              color:
                                              const Color(0xFF696969),
                                              spreadRadius: -5,
                                              blurRadius: 10,
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: HittapaRoundButton(
                                onClick: () {
                                  _filter.location = null;
                                  dispatch(SetEventFilter(filter: _filter));
                                  Navigator.of(context).pop();
                                },
                                text: LocaleKeys.global_cancel.tr().toUpperCase(),
                                isNormal: true,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: HittapaRoundButton(
//                            onClick: () => navigateToSettingScreen(context),
                                onClick: (){
                                  if (_selected != null && _selected != '') {
                                    for(var i=0; i<_locations.length; i++) {
                                      if(_locations[i].address == _selected) {
                                        _filter.location = _locations[i];
                                        break;
                                      }
                                    }
                                    dispatch(SetEventFilter(filter: _filter));                                    
                                  }                                  
                                  Navigator.of(context).pop();
                                },
                                text: LocaleKeys.global_save.tr().toUpperCase(),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
