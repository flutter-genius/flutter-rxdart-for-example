import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:hittapa/models/event.dart';
import 'package:hittapa/models/message.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/services/node_service.dart';
import 'package:hittapa/theme.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/utils/routes.dart';
import 'package:hittapa/widgets/show_confirm_dialog.dart';

import '../global.dart';
import 'image_picker_handler.dart';
import 'round_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hittapa/global_export.dart';

//ignore: must_be_immutable
class NewAddAssetsDialog extends StatelessWidget {
  final Function onSelect;
  final AnimationController controller;
  final BuildContext context;
  final EventModel event;
  final bool isForward;
  final UserModel user;
  bool _isAcceptedEvent = false;
  String _returnValueToParentWidget;
  String deepLinkUrl;

  NewAddAssetsDialog(
      {this.onSelect,
        this.controller,
        this.context,
        this.event,
        this.isForward = false,
        this.user
      });

  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;

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
    if(user!=null && user.uid != null && (user.uid == event.ownerId || event.participantsAccepted.contains(user.uid))){
      _isAcceptedEvent = true;
    }
    if (event.startDT.isBefore(DateTime.now())) {
      _isAcceptedEvent = false;
    }
  }

  void dispose() {
    controller.dispose();
  }

  startTime() async {
    var _duration = Duration(milliseconds: 200);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pop(this.context, _returnValueToParentWidget);
  }

  dismissDialog() {
    controller.reverse();
    startTime();
  }

  Future showAddDialog(BuildContext context, String _deepLinkUrl) async{
    if (controller == null ||
        _drawerDetailsPosition == null ||
        _drawerContentsOpacity == null) {
      return;
    }
    controller.forward();
    deepLinkUrl = _deepLinkUrl;
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
                child: _isAcceptedEvent ? _acceptedWidget(context) : _unacceptedWidget(context),
              )
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _acceptedWidget(BuildContext context){
    return Column(
      children: <Widget>[
        SizedBox(
          height: 36,
        ),
        Text(
          LocaleKeys.panel_choose_function.tr(),
          style: TextStyle(
              fontSize: 17,
              color: NAVIGATION_NORMAL_TEXT_COLOR,
              fontWeight: FontWeight.w500),
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
                    linkUrl: deepLinkUrl,
                    chooserTitle: LocaleKeys.menu_about_hittapa.tr(),
                );
              }),
            )
          ],
        ),
        const SizedBox(height: 15.0),
        Row(
          children: <Widget>[
            Expanded(
              child: roundedButton(
                  LocaleKeys.panel_give_feedback.tr(),
                  EdgeInsets.symmetric(horizontal: 16),
                  Colors.white,
                  NAVIGATION_NORMAL_TEXT_COLOR, () {

              }),
            )
          ],
        ),
        const SizedBox(height: 15.0),
        Row(
          children: <Widget>[
            Expanded(
              child: roundedButton(
                  LocaleKeys.panel_report_user.tr(),
                  EdgeInsets.symmetric(horizontal: 16),
                  Colors.white,
                  NAVIGATION_NORMAL_TEXT_COLOR,
                      (){
                    _returnValueToParentWidget = 'isReport';
                    dismissDialog();
                      }),
            )
          ],
        ),
        const SizedBox(height: 15.0),
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
        SizedBox(
          height: 35,
        )
      ],
    );
  }

  Widget _unacceptedWidget(BuildContext context){
    return Column(
      children: <Widget>[
        SizedBox(
          height: 36,
        ),
        Text(
          LocaleKeys.panel_choose_function.tr(),
          style: TextStyle(
              fontSize: 17,
              color: NAVIGATION_NORMAL_TEXT_COLOR,
              fontWeight: FontWeight.w500),
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
                  linkUrl: deepLinkUrl,
//                  text: this.event.description,
                  chooserTitle: LocaleKeys.menu_about_hittapa.tr(),
                );
              }),
            )
          ],
        ),
        const SizedBox(height: 15.0),
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
        SizedBox(
          height: 35,
        )
      ],
    );
  }

  withdrawApplicant() {
    List<String> _declined = event.participantsDeclined;
    if (user!=null && !_declined.contains(user.uid)) {
      _declined.add(user.uid);
      NodeService().updateEvent(event.copyWith(participantsDeclined: _declined).toJson()).then((_){dismissDialog();});
    } else {
      dismissDialog();
    }
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
class ChattingMoreDialog extends StatelessWidget {
  final ImagePickerHandler listener;
  final Function onSelect;
  final AnimationController controller;
  final BuildContext context;
  final EventModel event;

  ChattingMoreDialog(
      {this.onSelect,
      this.controller,
      this.context,
      this.event,
      this.listener});

  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;

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
    listener.init(context);
  }

  void dispose() {
    controller.dispose();
  }

  startTime() async {
    var _duration = Duration(milliseconds: 200);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pop(this.context);
  }

  dismissDialog() {
    controller.reverse();
    startTime();
  }

  showMoreDialog(BuildContext context) {
    if (controller == null ||
        _drawerDetailsPosition == null ||
        _drawerContentsOpacity == null) {
      return;
    }
    controller.forward();
    showDialog(
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
                      height: 15,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: roundedButton(
                               LocaleKeys.panel_upload_from_camera.tr(),
                              EdgeInsets.symmetric(horizontal: 16),
                              Colors.white,
                              NAVIGATION_NORMAL_TEXT_COLOR,
                              () => listener.openGallery()),
                        )
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: roundedButton(
                               LocaleKeys.panel_take_a_picture.tr(),
                              EdgeInsets.symmetric(horizontal: 16),
                              Colors.white,
                              NAVIGATION_NORMAL_TEXT_COLOR,
                              () => listener.openCamera()),
                        )
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: roundedButton(
                              LocaleKeys.panel_share_your_location.tr(),
                              EdgeInsets.symmetric(horizontal: 16),
                              Colors.white,
                              NAVIGATION_NORMAL_TEXT_COLOR, () {
                            navigateToLocationPickerScreen(context)
                                .then((value) {
                              this.onSelect(
                                  '${value.coordinates.latitude},${value.coordinates.longitude}');
                              Navigator.of(context).pop();
                            });
                          }),
                        )
                      ],
                    ),
                    const SizedBox(height: 15.0),
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
class UserReportDialog extends StatelessWidget {
  final Function onSelect;
  final AnimationController controller;
  final BuildContext context;
  final EventModel event;
  final bool isForward;
  UserModel user;
  TextEditingController _reasonController = TextEditingController();
  String _reportOption;
  bool _isRequired = false, _isReport = false, _isQote = false;
  MessageModel message;

  UserReportDialog(
      {this.onSelect,
        this.controller,
        this.context,
        this.event,
        this.isForward = false,
        this.user
      });

  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;

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
    Navigator.of(context).pop(_isQote);
  }

  dismissDialog() {
    message = new MessageModel();
    _reportOption = null;
    _reasonController = new TextEditingController();
    _isReport = false;
    controller.reverse();
    startTime();
  }

  _sendUserReport() async {
    print(message);
    var _map = {
      "reportId": message.senderId,
      "reportName": message.senderName,
      "reportAvatar": message.senderAvatar,
      "sendId": user.uid,
      "sendName": user.username,
      "sendAvatar": user.avatar,
      "reportOption": _reportOption,
      "content": _reasonController.text
    };
    var _result = await NodeService().createReport(_map);
    if(_result != null && _result['data'] != null){
      print('@@@@@ successfully the report created');
    }
  }

  Future showAddDialog(BuildContext context, UserModel _user, MessageModel _message) async{
    if (controller == null ||
        _drawerDetailsPosition == null ||
        _drawerContentsOpacity == null) {
      return;
    }
    controller.forward();
    user = _user;
    _isQote = false;
    message = _message;
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

  Widget _commitWidget(context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 36,
        ),
        Text(
          LocaleKeys.panel_choose_option.tr(),
          style: TextStyle(
              fontSize: 17,
              color: NAVIGATION_NORMAL_TEXT_COLOR,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: roundedButton(
                  LocaleKeys.panel_qoute.tr(),
                  EdgeInsets.symmetric(horizontal: 16),
                  Colors.white,
                  NAVIGATION_NORMAL_TEXT_COLOR,
                      () {
                    _isQote = true;
                    dismissDialog();
                  }
              ),
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
                  LocaleKeys.panel_report.tr(),
                  EdgeInsets.symmetric(horizontal: 16),
                  Colors.white,
                  NAVIGATION_NORMAL_TEXT_COLOR, () {
                _isReport = true;
                (context as Element).markNeedsBuild();
              }),
            )
          ],
        ),
        const SizedBox(height: 15.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: roundedButton(
                  LocaleKeys.panel_cancel.tr(),
                  EdgeInsets.symmetric(horizontal: 16),
                  Colors.white,
                  NAVIGATION_NORMAL_TEXT_COLOR,
                      () {
                    dismissDialog();
                  }),
            ),
          ],
        ),
        SizedBox(
          height: 35,
        )
      ],
    );
  }


  Widget _reportWidget(context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 36,
        ),
        Text(
          LocaleKeys.panel_choose_or_write.tr(),
          style: TextStyle(
              fontSize: 17,
              color: NAVIGATION_NORMAL_TEXT_COLOR,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: roundedButton(
                  '${REPORT_OPTION[0]}',
                  EdgeInsets.symmetric(horizontal: 16),
                  Colors.white,
                  NAVIGATION_NORMAL_TEXT_COLOR,
                      () {
                    _reportOption = REPORT_OPTION[0];
                    (context as Element).markNeedsBuild();
                  }
              ),
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
                  '${REPORT_OPTION[1]}',
                  EdgeInsets.symmetric(horizontal: 16),
                  Colors.white,
                  NAVIGATION_NORMAL_TEXT_COLOR, () {
                _reportOption = REPORT_OPTION[1];
                (context as Element).markNeedsBuild();
              }),
            )
          ],
        ),
        const SizedBox(height: 15.0),
        Row(
          children: <Widget>[
            Expanded(
              child: roundedButton(
                '${REPORT_OPTION[2]}',
                EdgeInsets.symmetric(horizontal: 16),
                Colors.white,
                NAVIGATION_NORMAL_TEXT_COLOR,
                    () {
                  _reportOption = REPORT_OPTION[2];
                  (context as Element).markNeedsBuild();
                }
              ),
            )
          ],
        ),
        const SizedBox(height: 15.0),
        Container(
          width: MediaQuery.of(context).size.width-40,
          child: Text(
            LocaleKeys.panel_we_at_hittapa.tr(),
          ),
        ),
        const SizedBox(height: 15.0),
        Row(
          children: <Widget>[
            Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.all(0.0),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: _reasonController,
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.only(left: 15, right: 10, top: 5),
                      hintText: LocaleKeys.panel_write_reason.tr(),
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                    ),
                    minLines: 3,
                    maxLines: 4,
                    keyboardType: TextInputType.text,
                  ),
                )
            )
          ],
        ),
        _isRequired ? Container(
          padding: EdgeInsets.only(top: 5, bottom: 15),
          child: Text(LocaleKeys.panel_select_the_option.tr(), style: TextStyle(color: Colors.red, fontSize: 12),),
        ) : SizedBox(height: 15.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: roundedButton(
                  LocaleKeys.panel_cancel.tr(),
                  EdgeInsets.symmetric(horizontal: 26),
                  Colors.white,
                  NAVIGATION_NORMAL_TEXT_COLOR,
                      () {
                    dismissDialog();
                  }),
            ),
            Expanded(
              child: roundedButton(
                  LocaleKeys.global_submit.tr(),
                  EdgeInsets.symmetric(horizontal: 26),
                  AppTheme.GRADIENT_COLOR_ONE,
                  NAVIGATION_NORMAL_TEXT_COLOR,
                      () async {
                    await _reportConfirm(context);
                  }),
            )
          ],
        ),
        SizedBox(
          height: 35,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: Opacity(
          opacity: 1.0,
          child: Container(
            height: MediaQuery.of(context).size.height,
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
                  child: !_isReport ? _commitWidget(context) : _reportWidget(context),
                )
              ],
            ),
          ),
        ),
      )
    );
  }

  _reportConfirm(BuildContext context) async{
    if(_reportOption == null && _reasonController.text == null ){
      _isRequired = true;
      (context as Element).markNeedsBuild();
    }  else {
      _isRequired = false;
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
              await _sendUserReport();
              showSuccessDialog(context);
            },
          ),
          firstButton: HittapaRoundButton(
            text: LocaleKeys.global_discard.tr().toUpperCase(),
            isPopUp: true,
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
                        color: NAVIGATION_NORMAL_TEXT_COLOR, fontSize: 14),
                    text:
                    LocaleKeys.popup_by_clicking_continue.tr(),
                    children: <TextSpan>[
                      TextSpan(
                          text: LocaleKeys.popup_agree_to_the_term_dot.tr(),
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                                ..onTap = () async{
                                  await launchURL('hittapa.com/terms');
                                }
                        ),
                      TextSpan(text: ' and\n acknowledging the '),
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
  }


  showSuccessDialog(BuildContext context) async {
    await showDialog(context: context, useSafeArea: false, builder: (context) => ConfirmDialog(
        title: Center(child: Text('You have successfully withdraw from the event.', style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold))),
        firstButton: HittapaRoundButton(
          isPopUp: true,
          text: LocaleKeys.global_ok.tr().toUpperCase(),
          onClick: () {
            Navigator.of(context).pop();
            dismissDialog();
          },
        ),
        icon: Container(),
        yourWidget: Container(
          child: Center(
            child: Text(LocaleKeys.panel_we_value_your_concern.tr(), style: TextStyle(fontSize: 17, color: Colors.white)),
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
        color: _reportOption == buttonLabel ? Colors.grey : bgColor,
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
class ReportBehaviorDialog extends StatelessWidget {
  final Function onSelect;
  final AnimationController controller;
  final BuildContext context;
  final EventModel event;
  final bool isForward;
  UserModel user;
  TextEditingController _reasonController = TextEditingController();
  List<UserModel> users = [], reportUsers = [];
  List<bool> usersValue = [];
  String _reportOption;
  bool isRequired = false, isOpen = false, _ischecked = false, _isSubmit = false;
  MessageModel message;

  ReportBehaviorDialog(
      {this.onSelect,
        this.controller,
        this.context,
        this.event,
        this.isForward = false,
        this.user,
      });

  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;

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
    Navigator.of(context).pop(this.context);
  }

  dismissDialog() {
    _reportOption = null;
    _reasonController = new TextEditingController();
    reportUsers = [];
    users = [];
    isOpen = false;
    _ischecked = false;
    _isSubmit = false;
    controller.reverse();

    startTime();
  }

  _sendUserReport() async {
    print(message);
    var _map = {
      "reportUsers": reportUsers,
      "sendId": user.uid,
      "sendName": user.username,
      "sendAvatar": user.avatar,
      "reportOption": _reportOption,
      "content": _reasonController.text
    };
    var _result = await NodeService().createReportBehavior(_map);
    if(_result != null && _result['data'] != null){
      print('@@@@@ successfully the report created');
    }
  }

  showAddDialog(BuildContext context, List<UserModel> _users, UserModel _owner) {
    if (controller == null ||
        _drawerDetailsPosition == null ||
        _drawerContentsOpacity == null) {
      return;
    }
    controller.forward();
    users = _users;
    for(int i=0; i<users.length; i++){
      /// removing the my account


      usersValue.add(false);
    }
    /// adding the event owner

    showDialog(
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


  Widget _reportWidget(context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width-60,
              padding: EdgeInsets.only(left: 40),
              child:  Center(
                child: Container(
                  width: 45,
                  height: 5,
                  margin: EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                      color: CIRCLE_AVATAR_COLOR,
                      borderRadius: BorderRadius.all(Radius.circular(3))
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: (){
                dismissDialog();
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  color: Colors.grey
                ),
                child: Icon(Icons.close, size: 15, color: Colors.white,),
              )
            )
          ],
        ),
        Center(
          child: Text(LocaleKeys.panel_report_user.tr(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        ),
        SizedBox(height: 8,),
        Container(
          child: Center(
            child: Text(LocaleKeys.panel_we_take_every_report.tr(), style: TextStyle(fontSize: 15, color: Colors.black87),),
          )
        ),
        SizedBox(
          height: 110,
          child: isOpen ? Container(
            child: Column(
              children: [
                SizedBox(height: 10,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 0),
                  padding: EdgeInsets.all(0.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _reasonController,
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.only(left: 15, right: 10, top: 5),
                      hintText: LocaleKeys.panel_write_reason.tr(),
                      hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                    ),
                    minLines: 3,
                    maxLines: 4,
                    keyboardType: TextInputType.text,
                  ),
                ),
                SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ...(users).map<Widget>((e) {
                      GlobalKey btnKey = GlobalKey(debugLabel:e.uid.toString());
                      return Container(
                        child: GestureDetector(
                            key: btnKey,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  child: CachedNetworkImage(imageUrl: e.avatar ?? DEFAULT_AVATAR, fit: BoxFit.cover,),
                                )
                            )
                        ),
                      );
                    }).toList(),
                  ],
                )
              ],
            ),
          ) : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: users.length,
            itemBuilder: (context, index) => PopupMenuButton(
              color: Colors.transparent,
              icon: GestureDetector(
                  key: GlobalKey(debugLabel:index.toString()),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: 50,
                        height: 50,
                        child: CachedNetworkImage(imageUrl: users[index].avatar ?? DEFAULT_AVATAR, fit: BoxFit.cover,),
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
                                child: CachedNetworkImage(imageUrl: users[index].avatar ?? DEFAULT_AVATAR, fit: BoxFit.cover,),
                              )
                          ),
                          SizedBox(height: 5,),
                          TitleWidget(users[index], usersValue[index], (val){
                            print(val);
                            usersValue[index] = val;
                          }),
                        ],
                      ),
                    )
                ),
              ],
              offset: Offset(0, 0),
              elevation: 0,
            ),
          ) ,
        ),
        Container(
          height: 100,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Checkbox(
                    value: _ischecked,
                    onChanged: (value){
                      _ischecked = value;
                      (context as Element).markNeedsBuild();
                    },
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width-100,
                    child: Text(LocaleKeys.panel_i_assure_everything.tr(), style: TextStyle(fontSize: 14, color: Colors.black54),),
                  ),
                ],
              ),
              _isSubmit ? InkWell(
                    onTap: (){
                      if(_reasonController.text == null || _reasonController.text==''){
                        hittaPaToast(LocaleKeys.toast_input_report_reason.tr(), 1);
                      } else {
                        _reportConfirm(context);
                      }
                    },
                    child: Container(
                      width: 120,
                      height: 38,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                          color: Colors.blueGrey
                      ),
                      child: Center(
                        child: Text(LocaleKeys.global_submit.tr().toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 17),),
                      ),
                    ),
                  ) : InkWell(
                    onTap: (){
                      if(_ischecked){
                        bool _isSelected = false;
                        for(int i=0; i< usersValue.length; i++){
                          if(usersValue[i]){
                            reportUsers.add(users[i]);
                            _isSelected = true;
                          }
                        }
                        if( !_isSelected ) {
                          hittaPaToast(LocaleKeys.toast_select_report_users.tr(), 1);
                        } else {
                          _isSubmit = true;
                          isOpen = true;
                          (context as Element).markNeedsBuild();
                        }
                      }
                    },
                    child: Container(
                      width: 120,
                      height: 38,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                          color: _ischecked ? Colors.blueGrey : Colors.grey
                      ),
                      child: Center(
                        child: Text(LocaleKeys.global_next.tr(), style: TextStyle(color: Colors.white, fontSize: 17),),
                      ),
                    ),
                  ),
            ],
          )
        ),
        SizedBox(height: 20,)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: SingleChildScrollView(
          child: Opacity(
            opacity: 1.0,
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: SizedBox(),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40)),
                    ),
                    child: _reportWidget(context),
                  )
                ],
              ),
            ),
          ),
        )
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
            await _sendUserReport();
            showSuccessDialog(context);
          },
        ),
        firstButton: HittapaRoundButton(
          text: LocaleKeys.global_discard.tr().toUpperCase(),
          isPopUp: true,
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
                      color: Colors.white, fontSize: 17),
                  text:
                  LocaleKeys.popup_by_clicking_continue.tr(),
                  children: <TextSpan>[
                    TextSpan(
                        text: LocaleKeys.popup_agree_to_the_term_dot.tr(),
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


  showSuccessDialog(BuildContext context) async {
    await showDialog(context: context, useSafeArea: false, builder: (context) => ConfirmDialog(
        title: Center(child: Text(LocaleKeys.panel_your_report_sent.tr(), style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold))),
        firstButton: HittapaRoundButton(
          isPopUp: true,
          text: LocaleKeys.global_ok.tr().toUpperCase(),
          onClick: () {
            Navigator.of(context).pop();
            dismissDialog();
          },
        ),
        icon: Container(),
        yourWidget: Container(
          child: Center(
            child: Text(LocaleKeys.panel_we_value_your_concern.tr(), style: TextStyle(fontSize: 17, color: Colors.white)),
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
        color: _reportOption == buttonLabel ? Colors.grey : bgColor,
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

//ignore: must_be_immutable
class AccepedUserDialog extends StatelessWidget {
  final Function onSelect;
  final AnimationController controller;
  final BuildContext context;
  final EventModel event;
  final bool isForward;
  List<UserModel> users;
  UserModel eventOwner;
  bool _isshow;

  AccepedUserDialog(
      {this.onSelect,
        this.controller,
        this.context,
        this.event,
        this.isForward = false,
        this.users,
        this.eventOwner,
      });

  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;

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
    _isshow = true;
  }

  void dispose() {
    controller.dispose();
  }

  startTime() async {
    var _duration = Duration(milliseconds: 200);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    _isshow = true;
    Navigator.of(context).pop(this.context);
  }

  dismissDialog() {
    _isshow = false;
    (context as Element).markNeedsBuild();
    startTime();
  }

  showAddDialog(BuildContext context) {
    if (controller == null ||
        _drawerDetailsPosition == null ||
        _drawerContentsOpacity == null) {
      return;
    }
    controller.forward();

    showDialog(
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
    return _isshow ? Material(
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
                height: event.categoryId == '5faaa4dadceaa674dee0f613' ? 400 : 312,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                    color: Colors.black.withOpacity(0.7),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: const Color(0xFF696969),
                        spreadRadius: -15,
                        blurRadius: 40,
                      ),
                    ]
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: (){
                        dismissDialog();
                      },
                      child: Container(
                        width: 45,
                        height: 5,
                        margin: EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                            color: CIRCLE_AVATAR_COLOR,
                            borderRadius: BorderRadius.all(Radius.circular(3))
                        ),
                      ),
                    ),
                    Text(LocaleKeys.event_detail_event_attendees.tr(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),),
                    Container(
                      height: 180,
                      child: GridView.count(
                          crossAxisCount: 3,
                          childAspectRatio: 1,
                          padding: EdgeInsets.all(10),
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                          children: <Widget>[
                            ...users.map<Widget>((e) {
                              return Container(
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child:CachedNetworkImage(
                                        imageUrl: e.avatar ?? DEFAULT_AVATAR,
                                        fit: BoxFit.cover,
                                        height: 60,
                                        width: 60,
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      '${e.username}, ${e.birthday != null ? ageCalculate(e.birthday) : "20"} ${getGenderCharacter(e.gender)}',
                                      style: TextStyle(fontSize: 13, color: Colors.white),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ]
                      ),
                    ),
                    Container(
                      height: event.categoryId == '5faaa4dadceaa674dee0f613' ? 168 : 80,
                      decoration: BoxDecoration(
                          color: Colors.black
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.black
                            ),
                            child: Row(
                              children: <Widget>[
                                eventOwnerWidget(eventOwner, false, false),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 17),
                                    child: HittapaRoundButton(
                                      isGoogleColor: true,
                                      onClick: () => navigateToMessageScreen(context, event),
                                      text: LocaleKeys.message_message.tr(),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            height: 80,
                          ),
                          event.categoryId == '5faaa4dadceaa674dee0f613' ? Container(
                            child: Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer odio metus, iaculis ut ornare vitae, auctor vel urna.',
                              style: TextStyle(color: Color(0xFFD0021B), fontSize: 13,),
                            ),
                          ) : Container(),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ) : Container();
  }
}