import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/global_export.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset('assets/arrow-back.svg'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        backgroundColor: Colors.white,
        title: Text(
          LocaleKeys.about_us_aboutus.tr(),
          style: TextStyle(
              color: TITLE_TEXT_COLOR,
              fontWeight: FontWeight.w600,
              fontSize: 21),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 14),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
                text: LocaleKeys.menu_about_hittapa.tr(),
                style: TextStyle(
                    color: NAVIGATION_NORMAL_TEXT_COLOR,
                    fontWeight: FontWeight.w500,
                    fontSize: 24),
                children: <TextSpan>[
                  TextSpan(
                      text:
                          '''\n\n HittaPå  is an app that instantly  connects people with similar interests through an activi-ty of their choice. The app. simply allows one to set-up a  activity or search for an activi-ty in the community. HittaPå users have much in common but the most significant com-mon denominator is that our users wants to get socially active by getting involved in an activity of their choice and as an result of that expand their network.''',
                      style: TextStyle(fontSize: 17)),
                  TextSpan(
                      text:
                          '''\n\n With this app one will have fewer involuntary loneliness you know one of those times we all had where you would want to set up or join an activity but you have no one in your network to do it with.''',
                      style: TextStyle(fontSize: 17)),
                  TextSpan(
                      text:
                          '''\n\n Join this dynamic community to either set up an activity of your interest or join one of the thousands activities available in your newsfeed.''',
                      style: TextStyle(fontSize: 17)),
                  TextSpan(
                    text: '''\n\n\nUse HittaPå to :''',
                  ),
                  TextSpan(
                      text:
                          '''\n\n a)\t Post an activity that you would want people in your community to join.''',
                      style: TextStyle(fontSize: 17)),
                  TextSpan(
                      text:
                          '''\n b)\t As an ’poster’ that is setting up the activity you can specify requirements that you would like your potential activity buddies to fulfil.  Requirements can be anything from you wanting to have a walk with a dog owner or going to pregnancy yoga.''',
                      style: TextStyle(fontSize: 17)),
                  TextSpan(
                      text:
                          '''\n c)\t Search for a variety of activities to instantly join given that they are of your interest and the geographical location of your choice.''',
                      style: TextStyle(fontSize: 17)),
                  TextSpan(
                      text:
                          '''\n d)\t Post pictures and feedback after an activity to encourage others to try the activity or simply to give the community feedback of the awesome time you had.''',
                      style: TextStyle(fontSize: 17)),
                  TextSpan(
                      text:
                          '''\n e)\t Arrange a meeting/ activity for a senior relative or friend ( senior account)''',
                      style: TextStyle(fontSize: 17)),
                  TextSpan(
                      text:
                          '''\n f)\t Arrange a meeting/activity for a junior relative or friend ( junior account).''',
                      style: TextStyle(fontSize: 17)),
                  TextSpan(
                      text:
                          '''\n\n The interaction between users are instant and the number of daily activities are vast. Our users also have the opportunity to set up ’new’ activity categories should it be rele-vant. Our team will take a day or two to approve it and t afterwards it should be a part of our range of activities.''',
                      style: TextStyle(fontSize: 17)),
                ]),
          ),
        ),
      ),
    );
  }
}
