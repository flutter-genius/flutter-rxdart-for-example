import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/widgets/gradient_button.dart';
import 'package:hittapa/widgets/hittapa_logo.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:hittapa/global_export.dart';

import '../../config.dart';

class WorkFlowScreen extends StatelessWidget {
  final controller = PageController();
  final Function onFinished;

  WorkFlowScreen({@required this.onFinished});

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(
          children: <Widget>[
            PageView(
              controller: controller,
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/workflows/workflow_1.jpeg'),
                          fit: BoxFit.cover)),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(),
                      ),
                      Container(
                        child: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam quam nulla, ullamcorper sit amet felis vel.',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.none,
                              fontFamily: appTheme.fontFamily2),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        height: 24,
                        child: Shimmer.fromColors(
                            baseColor: Color(0xFF9B9B9B),
                            highlightColor: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(LocaleKeys.workflow_swipe_to_continue.tr().toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.none,
                                        fontFamily: appTheme.fontFamily2)),
                                SizedBox(
                                  width: 14,
                                ),
                                SvgPicture.asset(
                                  'assets/swipe_icon.svg',
                                  height: 24,
                                  width: 24,
                                )
                              ],
                            )),
                        margin: EdgeInsets.only(
                          bottom: 40,
                          top: 28,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/workflows/workflow_2.jpeg'),
                          fit: BoxFit.cover)),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(),
                      ),
                      Container(
                        child: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam quam nulla, ullamcorper sit amet felis vel.',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.none,
                              fontFamily: appTheme.fontFamily2),
                          textAlign: TextAlign.center,
                        ),
                        margin: const EdgeInsets.symmetric(
                            vertical: 91, horizontal: 14),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/workflows/workflow_3.jpeg'),
                          fit: BoxFit.cover)),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(),
                      ),
                      Container(
                        child: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam quam nulla, ullamcorper sit amet felis vel.',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.none,
                              fontFamily: appTheme.fontFamily2),
                          textAlign: TextAlign.center,
                        ),
                        margin: const EdgeInsets.symmetric(
                            vertical: 91, horizontal: 14),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/workflows/workflow_4.jpeg'),
                          fit: BoxFit.cover)),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(),
                      ),
                      Container(
                        child: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam quam nulla, ullamcorper sit amet felis vel.',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.none,
                              fontFamily: appTheme.fontFamily2),
                          textAlign: TextAlign.center,
                        ),
                        margin:
                            EdgeInsets.symmetric(vertical: 91, horizontal: 14),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/workflows/workflow_5.jpeg'),
                          fit: BoxFit.cover)),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(),
                      ),
                      Container(
                        child: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam quam nulla, ullamcorper sit amet felis vel.',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.none,
                              fontFamily: appTheme.fontFamily2),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        child: GradientButton(LocaleKeys.workflow_get_Started.tr().toUpperCase(), () {
                          onFinished();
                        }),
                        height: 48,
                        width: 200,
                        margin: EdgeInsets.only(top: 16, bottom: 28),
                      )
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              bottom: 147,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SmoothPageIndicator(
                    controller: controller,
                    count: 5,
                    effect: WormEffect(
                      dotWidth: 8,
                      dotHeight: 8,
                      activeDotColor: GRADIENT_COLOR_ONE,
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: 10,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SafeArea(
                    child: HittapaLogo(),
                  )
                ],
              ),
            ),
            Positioned(
              top: 20,
              right: 30,
              child: SafeArea(
                child: IconButton(
                  onPressed: () => onFinished(),
                  icon: Text(
                    LocaleKeys.workflow_skip.tr().toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),)
              ),
            )
          ],
        ),
      ),
    );
  }
}
