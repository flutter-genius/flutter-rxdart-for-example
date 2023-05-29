import 'package:flutter/material.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/screens/dashboard/old_component.dart';
import 'package:hittapa/screens/dashboard/passed_component.dart';
import 'package:hittapa/screens/dashboard/upcoming_component.dart';
import 'package:hittapa/global_export.dart';

class ActivitiesComponent extends StatelessWidget {

  final Function onClick;

  const ActivitiesComponent({Key key, this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: BACKGROUND_COLOR,
        body: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              color: Colors.white,
              child: TabBar(
                unselectedLabelColor: BORDER_COLOR,
                labelColor: NAVIGATION_NORMAL_TEXT_COLOR,
                indicatorColor: GRADIENT_COLOR_ONE,
                tabs: <Widget>[
                  Tab(
                    text: LocaleKeys.activites_upcoming.tr(),
                  ),
                  Tab(
                    text:  LocaleKeys.activites_my_passed.tr(),
                  ),
                  Tab(
                    text:  LocaleKeys.activites_passed.tr(),
                  )
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  UpcomingComponent(onClick: onClick,),
                  PassedComponent(onClick: onClick,),
                  OldComponent(onClick: onClick,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
