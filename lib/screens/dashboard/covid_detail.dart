import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/models/covid.dart';
import 'package:hittapa/models/user.dart';
import 'package:hittapa/widgets/hittapa_imageview.dart';

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hittapa/global_export.dart';


class CovidDetailScreen extends StatefulWidget {
  final CovidModel covidModel;
  CovidDetailScreen({this.covidModel});
  @override
  _CovidDetailScreenState createState() => _CovidDetailScreenState();
}

class _CovidDetailScreenState extends State<CovidDetailScreen>
    with TickerProviderStateMixin {
  UserModel user;
  CovidModel covidModel;
  List<String> _images = [];



  @override
  void initState() {
    super.initState();
    covidModel = widget.covidModel;
    for(int i=0; i<covidModel.images.length; i++){
      _images.add(covidModel.images[i].url);
    }
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;

    return StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        builder: (context, store) {
          AppState state = store.state;
          user = state.user;
          return Builder(
            builder: (context) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: Stack(children: <Widget>[
                  SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                height: MediaQuery.of(context).size.width,
                                child: Stack(children: <Widget>[
                                  HittapaImageView(
                                      title: covidModel.title,
                                      eventId: covidModel.id,
                                      images: _images,
                                      files: null, //widget.images,
                                      isGuest: false,
                                  ),
                                  Positioned(
                                      top: MediaQuery.of(context).size.width - 50,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Center(
                                          child: Text(covidModel.semiTitle != null ? covidModel.semiTitle : '', style: TextStyle(fontWeight: FontWeight.w500, color: BORDER_COLOR, fontSize: 17),),
                                        ),
                                      )
                                  ),
                                ])),
                            Container(
                              child: Center(
                                child: Text(covidModel.title != null ? covidModel.title : '', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 22),),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 20),
                              child: Text(
                                covidModel.description != null ? covidModel.description : '',
                                style: TextStyle(
                                    color: NAVIGATION_NORMAL_TEXT_COLOR,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(height: 30,),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 15,
                                      ),
                                      SvgPicture.asset(
                                        'assets/time_outline.svg',
                                        width: 16,
                                        height: 18,
                                        color: BORDER_COLOR,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        LocaleKeys.global_publish.tr() + " ",
                                        style: TextStyle(
                                          color: BORDER_COLOR,
                                          fontSize: 14
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        DateFormat('d MMM, HH:mm')
                                            .format(covidModel.publishDate),
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        ' hr',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14
                                        ),
                                      ),
                                    ],
                                  ),
                                  covidModel.websiteLink != null ? InkWell(
                                    onTap: (){
                                      _launchURL(covidModel.websiteLink);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(right: 15),
                                      height: 25,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          color: BORDER_COLOR,
                                          borderRadius: BorderRadius.all(Radius.circular(16))
                                      ),
                                      child: Center(
                                        child: Text(LocaleKeys.global_publish.tr().toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),),
                                      ),
                                    ),
                                  ) : Container(),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ])),
                  Container(
                    height: 95,
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                      actions: <Widget>[
                        IconButton(
                          icon: SvgPicture.asset('assets/share_icon.svg'),
                          onPressed: () {
                            FlutterShare.share(
                              title: covidModel.title,
//                                text: event.description,
                              linkUrl: 'google.com',
                              chooserTitle: 'Hittapa ' + LocaleKeys.menu_share.tr(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ]),
              );
            },
          );
        });
  }

  _launchURL(String _link) async {
    print(_link);
    String url = _link.contains('http') ? _link :'https://' + _link;
    print(url);
    await launch(url);
  }
}
