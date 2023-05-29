import 'dart:async';
import 'package:hittapa/services/node_service.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/models/feedback.dart';
import 'package:hittapa/models/event.dart';
import 'package:hittapa/models/models.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../global.dart';
import 'package:hittapa/global_export.dart';

class PastBottomHeader extends StatefulWidget {
  final EventModel event;
  final UserModel user;
  final Function onTapRate;
  final int rate;
  final PanelController controller;

  PastBottomHeader({this.event, this.user, this.rate, this.onTapRate, this.controller});
  @override
  _PastBottomHeaderState createState() => _PastBottomHeaderState();
}

class _PastBottomHeaderState extends State<PastBottomHeader> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Offset> _offsetAnimation;
  // ignore: non_constant_identifier_names
  int _selected_mark = 0;
  bool _ischecked = false, _isSecondCheck = false;


  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _offsetAnimation = widget.event.feedback.length==0 ? Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.5)).animate(_animationController) : Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero).animate(_animationController);
    Timer(Duration(milliseconds: 700), () {
      if (this.mounted) _animationController.forward();
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        position: _offsetAnimation,
        child: headerWidget()
    );
  }

  Widget headerWidget() {
    return Container(
      height: _ischecked ? 260 : 180,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            const BoxShadow(
                color: const Color(0x56C9CFD7),
                blurRadius: 22,
                offset: Offset(0, -12)
            ),
          ],
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(40), topLeft: Radius.circular(40)),
          color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 35,
            height: 5,
            margin: EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
                color: CIRCLE_AVATAR_COLOR,
                borderRadius: BorderRadius.all(Radius.circular(3))
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                (widget.event.feedback ?? []).indexWhere((element) => element.userId == widget.user.uid) >= 0 ?
                'Event feedback' : LocaleKeys.event_detail_how_was_the_event.tr(),
                style: TextStyle(
                  fontSize: 17,
                  color: NAVIGATION_NORMAL_TEXT_COLOR,),
              ),
              Stack(
                children: <Widget>[
                  Container(
                    width: 33,
                    height: 25,
                    child: FittedBox(
                      alignment: Alignment.bottomCenter,
                      fit: BoxFit.cover,
                      child: SvgPicture.asset('assets/bells.svg',),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '${(widget.event.feedback ?? []).length}',
                        style: TextStyle(color: Colors.white, fontSize: 12)
                      ),
                      height: 14,
                      width: 14,
                      decoration: BoxDecoration(
                          color: Color(0xFFFD5805),
                          borderRadius: BorderRadius.all(Radius.circular(7))
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 1,),
          Expanded(
            child:  Center(
              child: (widget.event.feedback ?? [])
                  .indexWhere((element) => element.userId == widget.user.uid) >= 0 ?
              Builder(
                builder: (context) {
                  Timer(Duration(seconds: 5), () {
                    if (mounted) widget.controller.open();
                  });
                  return feedbackWidget(widget.event.feedback[0], context);
                },
              ) :
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      feedTypeWidget(LocaleKeys.global_was_fun.tr(), 3),
                      feedTypeWidget(LocaleKeys.global_was_interesting.tr(), 4),
                      feedTypeWidget(LocaleKeys.global_was_amazing.tr(), 5),
                    ],
                  ),
                  SizedBox(height: 10,),
                  _ischecked ? Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Checkbox(
                            value: _isSecondCheck,
                            onChanged: (value){
                              setState(() {
                                _isSecondCheck = value;
                              });
                            },
                          ),
                          Text(
                            LocaleKeys.widget_annonymus_feedback_optional.tr(),
                            style: TextStyle(color: Colors.black54, fontSize: 18),
                          ),
                        ]
                      )
                    ) : Container(),
                  SizedBox(height: 5,),
                  _ischecked ? Container(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                    child: Text(
                        LocaleKeys.widget_mean_you_can.tr(),
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                  ): Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ischecked ? Container() : Row(
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                // ignore: unnecessary_statements
                                if (_ischecked) {
                                  _ischecked = false;
                                } else {
                                  _ischecked = true;
                                }
                              });
                              _offsetAnimation = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
                                  .animate(_animationController);
                              Timer(Duration(seconds: 1), () {
                                if (this.mounted) _animationController.forward();
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 15, right: 15),
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                color: BORDER_COLOR
                              ),
                              child: Center(
                                child: Text('?', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600))
                              ),
                            ),
                          ),
                          Text(
                            LocaleKeys.widget_annonymus_feedback.tr(),
                             style: TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: (){
                          if(_selected_mark != 0){
                            EventModel e = widget.event.copyWith(
                                feedback: [...widget.event.feedback ?? [], FeedbackModel(
                                    userId: widget.user.uid,
                                    avatar: widget.user.avatar,
                                    age: ageCalculate(widget.user.birthday),
                                    username: widget.user.username,
                                    createdAt: DateTime.now(),
                                    rating: _selected_mark,
                                    comment: FEEDBACK_TYPE[_selected_mark-1],
                                  gender: widget.user.gender,
                                  isAnnoys: _isSecondCheck
                                )]
                            );
                            NodeService().updateEvent(e.toJson()).then((value){
                              widget.controller.hide();
                              Timer(Duration(seconds: 2), () {
                                widget.controller.show();
                              });

                            });
                          }

                        },
                        child: Container(
                          width: 120,
                          height: 35,
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(14)),
                              color: _selected_mark !=0 ? Colors.blueGrey : Colors.grey
                          ),
                          child: Center(
                            child: Text(
                              LocaleKeys.global_submit.tr().toUpperCase(),
                               style: TextStyle(color: Colors.white, fontSize: 15),),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget feedTypeWidget(String title, int mark){
   return Container(
     width: (MediaQuery.of(context).size.width-60)/3,
     height: 30,
     padding: EdgeInsets.only(left: 5, right: 5),
     decoration: BoxDecoration(
       color: Colors.white,
       borderRadius: BorderRadius.all(Radius.circular(10)),
       boxShadow: [
         BoxShadow(
           color: Colors.grey.withOpacity(0.5),
           spreadRadius: 2,
           blurRadius: 7,
         ),
       ],
     ),
     child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
         Container(
           width: (MediaQuery.of(context).size.width-60)/3-28,
           child: Text(title, style: TextStyle(fontSize: 12,), overflow: TextOverflow.ellipsis,),
          ),
         InkWell(
           onTap:(){
             setState(() {
               _selected_mark = mark;
             });
           },
           child: _selected_mark != mark ? Container(
             width: 15,
             height: 15,
             decoration: BoxDecoration(
               color: Colors.grey[300],
               borderRadius: BorderRadius.all(Radius.circular(50)),
               boxShadow: [
                 BoxShadow(
                   color: Colors.grey.withOpacity(0.5),
                   spreadRadius: 2,
                   blurRadius: 2,
                 ),
               ],
             ),
           ) : Icon(Icons.check_circle_outline, size: 18, color: Colors.greenAccent),
         ),
       ],
     ),
   );
  }
}

class PastBottomBody extends StatelessWidget {
  final EventModel event;
  final UserModel user;
  final int rate;
  final PanelController controller;
  PastBottomBody({this.event, this.user, this.rate, this.controller});
  @override
  Widget build(BuildContext context) {
    return feedbackBody(context);
  }

  Widget feedbackBody(BuildContext context) {
    ApplicantStatusType _type = event.statusType(user.uid);

    if (
    (_type == ApplicantStatusType.pastAttendees ||
        _type == ApplicantStatusType.pastMy) && !event.isGivenFeedback(user.uid)
    )
      return Container(
        margin: EdgeInsets.only(top: 160),
        height: 0,
        color: Colors.white,
      );
    else if (event.isPassed && (event.feedback ?? []).length > 1) {
      return Container(
        margin: EdgeInsets.only(top: 160),
        padding: EdgeInsets.symmetric(horizontal: 15),
        color: Colors.white,
        child: ListView(
           children: event.feedback.map((e) => feedbackWidget(e, context)).toList(),
        ),
      );
    }
    return Container(
      margin: EdgeInsets.only(top: 160),
      height: 0,
      color: Colors.white,
    );
  }
}


Widget feedbackWidget(FeedbackModel item, BuildContext context) {
  return Container(
    margin: EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Container(
          width: 60,
          height: 60,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30))
          ),
          child: CachedNetworkImage(
            imageUrl: item.isAnnoys ? DEFAULT_AVATAR : item?.avatar ?? DEFAULT_AVATAR,
            fit: BoxFit.cover,
            errorWidget:(context, msg, err) => SvgPicture.asset('assets/avatar_placeholder.svg'),
            placeholder: (context, msg) => SvgPicture.asset('assets/avatar_placeholder.svg'),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 16),
          width: MediaQuery.of(context).size.width - 90,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(children: [
                Text(RATING_STRING[item.rating ?? 0],
                  style: TextStyle(
                    color: BORDER_COLOR,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Expanded(child: SizedBox(),),
                Text(
                  DateFormat("dd.MM.yyyy hh:mm").format(
                      item.createdAt),
                  style: TextStyle(
                    color: BORDER_COLOR,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],),
              Text(
                item.comment,
                style: TextStyle(
                  color: NAVIGATION_NORMAL_TEXT_COLOR,
                  fontSize: 15,
                ),
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                item.isAnnoys ? '${getGenderCharacter(item.gender)}, ${item.age}.' + LocaleKeys.widget_feedback_as_anonymous.tr() : '${item.username} ${item.age}',
                style: TextStyle(
                  color: BORDER_COLOR,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),

      ],
    ),
  );
}

