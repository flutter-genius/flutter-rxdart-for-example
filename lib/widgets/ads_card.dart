import 'package:flutter/material.dart';
import 'package:hittapa/models/ads.dart';
import 'package:hittapa/models/event_subcategory.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../global.dart';
import 'package:hittapa/global_export.dart';

// ignore: must_be_immutable
class AdsCard extends StatelessWidget {
  AdsCard(this.adsList, this.adsIndex);
  final List<AdsModel> adsList;
  final int adsIndex;
  final PageController controller = PageController(keepPage: true);

  int mainLength;
  AdsModel _currentAds;

  @override
  Widget build(BuildContext context) {
    mainLength = adsIndex~/11;
    _currentAds = adsList[mainLength%adsList.length];
    return Container(
      margin: EdgeInsets.only(top: 14),
      height: MediaQuery.of(context).size.width * 2 / 3 + 50,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Stack(
          children: <Widget>[
            PageView(
              controller: controller,
              children: _currentAds.images.map((e) => newpageWidget(e)).toList(),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SmoothPageIndicator(
                        controller: controller,
                        count: _currentAds.images.length,
                        effect: ScrollingDotsEffect(
                            dotHeight: 10,
                            dotWidth: 10,
                            activeDotColor: GRADIENT_COLOR_ONE
                        ),
                      )
                    ],
                  ),
                ),
              )
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              alignment: Alignment.center,
              width: 80,
              height: 25,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)
                  )
              ),
              child: Center(
                child: Text('Advertisement', style: TextStyle(fontSize: 12),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget pageWidget(String image) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: Image.asset(image, fit: BoxFit.cover,)),
        Positioned.fill(child: Container(color: Color.fromARGB(40, 0, 0, 0),)),
        Positioned.fill(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(child: SizedBox(),),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: Text(
                'adipiscing elit. Integer odio metus, iaculis ut ornare vitae, auctor vel urna.',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              child: FlatButton(
                clipBehavior: Clip.antiAlias,
                textColor: Colors.white,
                color: Color(0x30000000),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    side: BorderSide(
                        color: Colors.white,
                        width: 1,
                        style: BorderStyle.solid
                    )
                ),
                child: Text("View more"),
                onPressed: () {},
              ),
            ),
            SizedBox(height: 40,)
          ],
        ))
      ],
    );
  }

  Widget newpageWidget(ImageListModel _imageModel) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: Image.network(_imageModel.url, fit: BoxFit.cover,)),
        Positioned.fill(child: Container(color: Color.fromARGB(40, 0, 0, 0),)),
        Positioned.fill(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(child: SizedBox(),),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: Text(
                _imageModel.name !=null ? _imageModel.name : 'adipiscing elit. Integer odio metus, iaculis ut ornare vitae, auctor vel urna.',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              child: FlatButton(
                clipBehavior: Clip.antiAlias,
                textColor: Colors.white,
                color: Color(0x30000000),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    side: BorderSide(
                        color: Colors.white,
                        width: 1,
                        style: BorderStyle.solid
                    )
                ),
                child: Text(LocaleKeys.menu_view_more.tr(),),
                onPressed: (){
                  _launchURL(_currentAds.websiteLink);
                },
              ),
            ),
            SizedBox(height: 40,)
          ],
        ))
      ],
    );
  }

  _launchURL(String _link) async {
    String url = _link.contains('http') ? _link :'https://' + _link;
    print(url);
    await launch(url);
  }
}
