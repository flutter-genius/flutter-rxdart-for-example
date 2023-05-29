import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/global_export.dart';

class NoLocation extends StatelessWidget {
  final Function onClick;


  NoLocation(
      {@required this.onClick,});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white
      ),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height*0.1,),
          SvgPicture.asset('assets/svg/allow-location.svg', width: MediaQuery.of(context).size.width*0.2),
          Image.asset('assets/svg/close.png', width: 30,),
          Text(
            LocaleKeys.widget_it_seems_you_have_no.tr(),
             style: TextStyle(fontSize: 16),),
          Text(
            LocaleKeys.widget_internet_connection.tr(),
             style: TextStyle(fontSize: 16),),
          SizedBox(
            height: 25,
          ),
          InkWell(
            onTap: onClick,
            child: Container(
              decoration: BoxDecoration(
                  color: GOOGLE_COLOR,
                  borderRadius: BorderRadius.circular(20)
              ),
              width: 100,
              height: 40,
              child: Center(
                child: Text(
                  LocaleKeys.widget_refresh.tr(),
                   style: TextStyle(color: Colors.white, fontSize: 15),),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
