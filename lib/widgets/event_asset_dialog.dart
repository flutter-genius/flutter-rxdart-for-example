import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:hittapa/models/event.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/services/node_service.dart';
import 'package:hittapa/theme.dart';
import 'package:hittapa/utils/routes.dart';
import 'package:hittapa/widgets/show_confirm_dialog.dart';

import '../global.dart';
import 'round_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hittapa/global_export.dart';

//ignore: must_be_immutable
class MessageDialog extends StatelessWidget {
  final Function onSelect;
  final AnimationController controller;
  final BuildContext context;
  final EventModel event;
  final bool isForward;
  UserModel user;
  List<UserModel> otherUsers;
  int selectedUserIndex;
  String _isWithdraw;

  MessageDialog(
      {this.onSelect,
        this.controller,
        this.context,
        this.event,
        this.isForward = false,
        this.user
      });

  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;

  bool _isFirstWithRaw = false, _isSecondWithRaw = false;

  void initState() {
    _drawerContentsOpacity = CurvedAnimation(
      parent: new ReverseAnimation(controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(new CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    ));
  }

  void dispose() {
    controller.dispose();
  }

  startTime() async {
    var _duration = Duration(milliseconds: 200);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pop(_isWithdraw);
  }

  dismissDialog() {
    _isSecondWithRaw = false;
    _isFirstWithRaw = false;
    controller.reverse();
    startTime();
  }

  Future showAddDialog(BuildContext context, List<UserModel> _users, UserModel _user) async{
    if (controller == null ||
        _drawerDetailsPosition == null ||
        _drawerContentsOpacity == null) {
      return;
    }
    otherUsers = _users;
    user = _user;
    controller.forward();
    return await showDialog(
      context: context,
       useSafeArea: false,
      builder: (BuildContext context) => new SlideTransition(
        position: _drawerDetailsPosition,
        child: new FadeTransition(
          opacity: new ReverseAnimation(_drawerContentsOpacity),
          child: this,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Opacity(
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
                  color: CIRCLE_AVATAR_COLOR,
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
                      LocaleKeys.panel_more.tr(),
                      style: TextStyle(
                          fontSize: 17,
                          color: NAVIGATION_NORMAL_TEXT_COLOR,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: isForward ? 0 : 15,
                    ),
                    isForward
                        ? Container()
                        : Row(
                      children: <Widget>[
                        Expanded(
                          child: roundedButton(
                              LocaleKeys.panel_view_event.tr(),
                              EdgeInsets.symmetric(horizontal: 16),
                              Colors.white,
                              NAVIGATION_NORMAL_TEXT_COLOR, () {
                            Navigator.of(context).pop();
                            Navigator.pushNamed(
                                context, Routes.EVENT_DETAIL,
                                arguments: {"eventId": event});
                          }),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: roundedButton(
                              LocaleKeys.panel_share_event.tr(),
                              EdgeInsets.symmetric(horizontal: 16),
                              Colors.white,
                              NAVIGATION_NORMAL_TEXT_COLOR, () {
                            FlutterShare.share(
                                title: this.event.name,
                                linkUrl: 'App/Play store link',
                                text: this.event.description);
                          }),
                        )
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: roundedButton(
                              LocaleKeys.panel_withdraw.tr(),
                              EdgeInsets.symmetric(horizontal: 16),
                              Colors.white,
                              NAVIGATION_NORMAL_TEXT_COLOR,
                                  (){
                                _isFirstWithRaw = true;
                                (context as Element).markNeedsBuild();
                                    //withdrawApplicant();
                                  }),
                        )
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    _isFirstWithRaw
                        ? _isSecondWithRaw
                        ? Container(
                      child: Column(
                        children: [
                          Container(
                              child: Center(
                                child: Text(LocaleKeys.panel_choose.tr(), style: TextStyle(fontSize: 18, color: Colors.black87),),
                              )
                          ),
                          Container(
                            height: 110,
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: otherUsers.length,
                              itemBuilder: (context, index) => PopupMenuButton(
                                color: Colors.transparent,
                                icon: GestureDetector(
                                    key: GlobalKey(debugLabel:index.toString()),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          child: CachedNetworkImage(imageUrl: otherUsers[index].avatar ?? DEFAULT_AVATAR, fit: BoxFit.cover,),
                                        )
                                    )
                                ),
                                padding: EdgeInsets.all(0),
                                itemBuilder: (context)=>[
                                  PopupMenuItem(
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Column(
                                          children: [
                                            ClipRRect(
                                                borderRadius: BorderRadius.circular(50),
                                                child: Container(
                                                  width: 70,
                                                  height: 70,
                                                  child: CachedNetworkImage(imageUrl: otherUsers[index].avatar ?? DEFAULT_AVATAR, fit: BoxFit.cover,),
                                                )
                                            ),
                                            SizedBox(height: 5,),
                                            TitleWidget(otherUsers[index], selectedUserIndex==index ? true : false, (val){
                                              print(val);
                                              if(val) {
                                                selectedUserIndex = index;
                                              } else {
                                                selectedUserIndex = -1;
                                              }
                                            }),
                                          ],
                                        ),
                                      )
                                  ),
                                ],
                                offset: Offset(0, 0),
                                elevation: 0,
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: roundedButton(
                                    LocaleKeys.panel_cancel.tr(),
                                    EdgeInsets.symmetric(horizontal: 16),
                                    Colors.white,
                                    NAVIGATION_NORMAL_TEXT_COLOR,
                                        () => dismissDialog()),
                              ),
                              Expanded(
                                child: roundedButton(
                                    LocaleKeys.global_submit.tr(),
                                    EdgeInsets.symmetric(horizontal: 16),
                                    Colors.grey,
                                    NAVIGATION_NORMAL_TEXT_COLOR,
                                        (){
                                      if(selectedUserIndex==null || selectedUserIndex <0){
                                        hittaPaToast(LocaleKeys.toast_select_assign_user.tr(), 1);
                                      } else {
                                        _reportConfirm(context);
                                      }
                                        }),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                        : Container(
                      child: Column(
                        children: [
                          Container(
                              child: Center(
                                child: Text(event.ownerId == user.uid ? LocaleKeys.panel_withdraw_from_event_as.tr() : 'Withdraw from event as a attendee' , style: TextStyle(fontSize: 18, color: Colors.black87),),
                              )
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 20, top: 15),
                            child: Text(
                              LocaleKeys.panel_withdraw_from_event_where.tr(),
                               style: TextStyle(color: Colors.black87, fontSize: 13),),
                          ),
                          InkWell(
                            onTap: (){
                              dismissDialog();
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                              padding: EdgeInsets.all(13),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  color: Colors.grey
                              ),
                              child: Center(
                                child: Text(
                                  LocaleKeys.panel_go_back.tr(),
                                  style: TextStyle(color: Colors.white),),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              if(event.ownerId == user.uid){
                                _isSecondWithRaw = true;
                                (context as Element).markNeedsBuild();
                              } else {
                               _reportConfirm(context);
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.all(20),
                              padding: EdgeInsets.all(13),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [GRADIENT_COLOR_ONE, GRADIENT_COLOR_TWO]),
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Center(
                                child: Text(
                                  LocaleKeys.panel_i_already.tr(),
                                  style: TextStyle(color: Colors.white),),
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: roundedButton(
                                    LocaleKeys.panel_cancel.tr(),
                                    EdgeInsets.symmetric(horizontal: 16),
                                    Colors.white,
                                    NAVIGATION_NORMAL_TEXT_COLOR,
                                        () => dismissDialog()),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                        : Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: roundedButton(
                                LocaleKeys.panel_cancel.tr(),
                                EdgeInsets.symmetric(horizontal: 16),
                                Colors.white,
                                NAVIGATION_NORMAL_TEXT_COLOR,
                                    () => dismissDialog()),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _reportConfirm(BuildContext context) async{
    await showDialog(context: context, useSafeArea: false, builder: (context) => ConfirmDialog(
        title: Column(
          children: [
            Center(child: Text(LocaleKeys.popup_i_belive.tr(), style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold))),
            Center(child: Text(LocaleKeys.popup_nothing_but.tr(), style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold)))
          ],
        ),
        secondButton: HittapaRoundButton(
          text: LocaleKeys.global_continue.tr().toUpperCase(),
          isPopUp: true,
          onClick: () async {
            Navigator.of(context).pop();
            if(user != null && user.uid == event.ownerId){
              await withdrawAppFromOwner();
              // _isWithdraw = '2';
              _isWithdraw = otherUsers[selectedUserIndex].uid;
            } else {
              await withdrawApplicant();
              // _isWithdraw = '1';
              _isWithdraw = user.uid;
            }
            showSuccessDialog(context);
          },
        ),
        firstButton: HittapaRoundButton(
          isPopUp: true,
          text: LocaleKeys.global_discard.tr().toUpperCase(),
          onClick: () => Navigator.of(context).pop(),
          isNormal: true,
        ),
        icon: Container(),
        yourWidget: Column(
          children: <Widget>[
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: TextStyle(
                      color: Colors.white, fontSize: 14),
                  text:
                  LocaleKeys.popup_by_clicking_continue.tr(),
                  children: <TextSpan>[
                    TextSpan(
                        text: LocaleKeys.global_terms_of_use.tr(),
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                                ..onTap = () async{
                                  await launchURL('hittapa.com/terms');
                                }
                      ),
                    TextSpan(text: LocaleKeys.hittapa_sign_and_acknowledging.tr(),),
                    TextSpan(
                        text: LocaleKeys.global_privacy_policy.tr(),
                        style: TextStyle(
                            decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                                ..onTap = () async{
                                  await launchURL('hittapa.com/privacy');
                                }
                    )
                  ]),
            )
          ],
        )
    ));
  }

  withdrawApplicant() async{
    List<String> _declined = event.participantsDeclined;
    List<String> _clined = event.participantsAccepted;

    if (user!=null && !_declined.contains(user.uid)) {
      _declined.add(user.uid);
      _clined.remove(user.uid);
      NodeService().updateEvent(event.copyWith(participantsDeclined: _declined, participantsAccepted: _clined).toJson());
    } else {
      print('@@@@@ withdraw applicant');
    }
  }

  withdrawAppFromOwner() async {
    List<String> _declined = event.participantsDeclined;
    List<String> _clined = event.participantsAccepted;
    print('@@@@@ this is the withdraw event own user');
    print(user.uid);

    _declined.add(user.uid);
    _clined.remove(otherUsers[selectedUserIndex].uid);
    NodeService().updateEvent(event.copyWith(participantsDeclined: _declined, participantsAccepted: _clined, ownerId: otherUsers[selectedUserIndex].uid, ownerImageUrl: otherUsers[selectedUserIndex].avatar).toJson());

  }

  showSuccessDialog(BuildContext context) async {
    await showDialog(context: context, useSafeArea: false, builder: (context) => ConfirmDialog(
        isCenter: true,
        title: Center(
          child: Text(
            'You have successfully withdraw from the event.', 
            style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        firstButton: HittapaRoundButton(
          isPopUp: true,
          text: LocaleKeys.global_ok.tr().toUpperCase(),
          onClick: () {
            dismissDialog();
            Navigator.of(context).pop();
          },
        ),
        icon: Container(),
        yourWidget: Container(
          child: Center(
            child: Text(
              LocaleKeys.panel_we_value_your_concern.tr(),
              style: TextStyle(fontSize: 17, color: Colors.white)),
          ),
        )
    ));
  }

  Widget roundedButton(String buttonLabel, EdgeInsets margin, Color bgColor,
      Color textColor, Function onTap) {
    return Container(
      margin: margin,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        color: bgColor,
        padding: EdgeInsets.all(15.0),
        child: Text(
          buttonLabel,
          style: TextStyle(
              color: textColor, fontSize: 15.0, fontWeight: FontWeight.w500),
        ),
        onPressed: () => onTap(),
      ),
    );
  }
}

//ignore: must_be_immutable
class TitleWidget extends StatefulWidget {
  UserModel _user;
  bool _isSelected;
  Function _function;
  TitleWidget(this._user, this._isSelected, this._function);
  @override
  _TitleWidgetState createState() => _TitleWidgetState();
}

class _TitleWidgetState extends State<TitleWidget> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8))
      ),
      padding: EdgeInsets.only(top: 2, bottom: 2, left: 7, right: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${widget._user.username.length > 8 ? widget._user.username.substring(0, 7) + '..' : widget._user.username}, ${widget._user.birthday != null ? ageCalculate(widget._user.birthday) : "20"} ${getGenderCharacter(widget._user.gender)}',
            style: TextStyle(fontSize: 13, color: Colors.black87),
          ),
          InkWell(
            onTap: (){
              setState(() {
                widget._isSelected = widget._isSelected ? false : true;
                widget._function(widget._isSelected);
              });
            },
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  color: widget._isSelected ? Colors.blueAccent : AppTheme.backgroundColor
              ),
            ),
          ),
        ],
      ),
    );
  }
}