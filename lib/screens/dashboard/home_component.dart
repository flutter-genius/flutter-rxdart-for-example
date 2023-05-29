import 'package:flutter/material.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/screens/dashboard/event_grid_component.dart';
import 'package:hittapa/screens/dashboard/locations_component.dart';

class HomeComponent extends StatelessWidget {
  final Function onClick;

  HomeComponent({this.onClick});

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: BACKGROUND_COLOR,
        body: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      EventGridComponent(onClick: onClick,),
                      LocationsComponent(onClick: onClick)
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
