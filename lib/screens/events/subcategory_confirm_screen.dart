import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/models/event_subcategory.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/global_export.dart';

class SubCategoryConfirmScreen extends StatelessWidget {
  final EventSubcategoryModel subcategory;
  final String router;

  SubCategoryConfirmScreen({this.subcategory, this.router});

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return Scaffold(
      body: StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        builder: (context, store){
          AppState state = store.state;
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: EdgeInsets.only(top: 90, bottom: 50),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(16))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 200,
                        height: 180,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16))
                        ),
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(child: (subcategory?.isSuspended ?? false) ? CachedNetworkImage(
                              imageUrl: subcategory?.thumbnail ?? '',
                              errorWidget: (context, msg, err) => Container(color: Colors.grey[300],),
                              fit: BoxFit.cover,
                            ) : SvgPicture.asset('assets/restrict.svg', fit: BoxFit.cover,)),
                            (subcategory?.isSuspended ?? false) ? Positioned.fill(
                              child:
                              BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                child: Container(color: Colors.black.withOpacity(0)),
                              ),
                            ) : Container(),
                            (subcategory?.isSuspended ?? false) ? Positioned.fill(
                              child: Center(
                                child: Icon(Icons.block, size: 65, color: Colors.white,),
                              ),
                            ) : Container(),
                          ],
                        ),
                      ),
                      SizedBox(height: 8,),
                      Text(
                        LocaleKeys.create_event_covid_restrictions.tr(),
                        style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w500,
                            color: NAVIGATION_NORMAL_TEXT_COLOR
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only( top: 18),
                        child: Text(
                          'Due to the spread of the COVID 19 we kindly recoment the practicing of physical distancing, this means we keep' +
                          'a distance of at leat 1m from each other.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: NAVIGATION_NORMAL_TEXT_COLOR
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30
                      ),
                      InkWell(
                        onTap: (){
                          navigateToCategoryScreen(context, appstate: state, pathIndex: 0);
                          // if (subcategory?.isSuspended ?? false) Navigator.of(context).pop();
                          // else Navigator.of(context).pushReplacementNamed(Routes.NEW_EVENT);
                        },
                        child: Container(
                          height: 48,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Center(
                            child: Text(
                              'I AGREE CONTINUE', 
                              style: TextStyle(
                                fontSize: 13, 
                                color: Colors.white, 
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      )
    );
  }
}
