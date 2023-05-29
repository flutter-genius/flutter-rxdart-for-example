import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/services/node_auth_service.dart';

class CallScreen extends StatefulWidget {
  String channelName;
  EventModel event;
  UserModel eventOwner;

  CallScreen({@required this.channelName, this.event, this.eventOwner});
  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  RtcEngine engine;
  Timer _timer;

  /// for knowing if the current user joined
  /// the call channel.
  bool joined = false;

  /// the remote user id.
  int remoteUid;

  /// if microphone is opened.
  bool openMicrophone = true;

  /// if the speaker is enabled.
  bool enableSpeakerphone = true;

  /// if call sound play effect is playing.
  bool playEffect = true;

  /// call time made.
  int callTime = 0;

  /// if the call was accepted
  /// by the remove user.
  bool callAccepted = false;

  /// if callTime can be increment.
  bool canIncrement = true;

  var stream;

  void startTimer() {
    const duration = Duration(seconds: 1);
    _timer = Timer.periodic(duration, (Timer timer) {
      if (mounted) {
        if (canIncrement) {
          setState(() {
            callTime += 1;
          });
        }
      }
    });
  }

  void switchMicrophone() {
    engine?.enableLocalAudio(!openMicrophone)?.then((value) {
      setState(() {
        openMicrophone = !openMicrophone;
      });
    })?.catchError((err) {
      debugPrint("caller ---> enableLocalAudio: $err");
    });
  }

  void switchSpeakerphone() {
    engine?.setEnableSpeakerphone(!enableSpeakerphone)?.then((value) {
      setState(() {
        enableSpeakerphone = !enableSpeakerphone;
      });
    })?.catchError((err) {
      debugPrint("caller ---> enableSpeakerphone: $err");
    });
  }

  Future<void> switchEffect() async {
    if (playEffect) {
      engine?.stopEffect(1)?.then((value) {
        setState(() {
          playEffect = false;
        });
      })?.catchError((err) {
        debugPrint("caller ---> stopEffect $err");
      });
    } else {
      engine
          ?.playEffect(
        1,
        await engine.getAssetAbsolutePath('assets/sounds/telephone-ring-02.mp3'),
        -1,
        1,
        1,
        100,
        true,
      )
          ?.then((value) {
        setState(() {
          playEffect = true;
        });
      })?.catchError((err) {
        debugPrint("caller ---> playEffect $err");
      });
    }
  }

  _readyFirebase() {
    stream = FirebaseFirestore.instance.collection("calls").doc(widget.channelName).snapshots();
    stream.listen((data) {
      if (!data.exists) {
        _timer?.cancel();
        engine?.destroy();
        stream = null;
        Navigator.of(context).pop();
        return;
      }
    });
  }

  Future<void> initRtcEngine() async {
    // Create RTC client instance
    engine = await RtcEngine.create(AGORA_APP_ID);
    // Define event handler
    engine.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (String channel, int uid, int elapsed) async {
        debugPrint('caller ---> joinChannelSuccess $channel $uid');
        if (mounted)
          setState(() {
            joined = true;
          });
        switchEffect();
      },
      leaveChannel: (stats) {
        debugPrint("caller ---> leaveChannel ${stats.toJson()}");
        if (mounted)
          setState(() {
            joined = false;
          });
      },
      userJoined: (int uid, int elapsed) {
        debugPrint('caller ---> userJoined $uid');
        setState(() {
          remoteUid = uid;
        });
        switchEffect();
        setState(() {
          if (!canIncrement) canIncrement = true;
          callAccepted = true;
        });
        startTimer();
      },
      userOffline: (int uid, UserOfflineReason reason) {
        debugPrint('caller ---> userOffline $uid');
        setState(() {
          remoteUid = null;
          canIncrement = false;
        });
        switchEffect();
        _endCall();
      },
    ));

    engine.enableAudio();
    engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    engine.setClientRole(ClientRole.Broadcaster);

    // temporary security call id
    final String callToken = await getAgoraChannelToken(widget.channelName, "publisher");
    if (callToken == null) {
      // go back
      Navigator.of(context).pop();
      return;
    }
    // Join channel
    await engine.joinChannel(callToken, widget.channelName, null, 0);
  }

  Future<String> getAgoraChannelToken(String channel, [String role = "subscriber"]) async {
    try {
      var _result = await NodeAuthService().getAgoraToken(widget.channelName, null);
      if (_result != null && _result['data'] != null) {
        return _result['data'];
      }
    } catch (e) {
      debugPrint("caller ---> getAgoraChannelToken: $e");
    }
    return null;
  }

  _cancelCall() async {
    _timer?.cancel();
    engine?.destroy();
    await FirebaseFirestore.instance.collection('calls').doc(widget.channelName).delete();
    Navigator.of(context).pop();
  }

  _endCall() async {
    _timer?.cancel();
    engine?.destroy();
    await FirebaseFirestore.instance.collection('calls').doc(widget.channelName).delete();
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    initRtcEngine();
    _readyFirebase();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    engine?.destroy();
    stream = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NAVIGATION_NORMAL_TEXT_COLOR,
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 100, bottom: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            remoteUid != null
                ? Column(
                    children: [
                      Text(
                        'CONNECTED',
                        style: TextStyle(color: BACKGROUND_COLOR, fontSize: 17),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${callTime.toString()}',
                        style: TextStyle(color: BACKGROUND_COLOR, fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : Text(
                    'CONNECTING',
                    style: TextStyle(color: BACKGROUND_COLOR),
                    textAlign: TextAlign.center,
                  ),
            Container(
              child: Container(
                width: 80,
                height: 80,
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        boxShadow: [
                          new BoxShadow(
                            color: GRAY_COLOR,
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          child: Container(
                            child: CachedNetworkImage(
                              width: 80,
                              height: 80,
                              imageUrl: widget.eventOwner?.avatar ?? DEFAULT_AVATAR,
                              placeholder: (context, url) => Center(
                                child: SvgPicture.asset(
                                  'assets/avatar_placeholder.svg',
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                              errorWidget: (context, url, err) => Center(
                                child: SvgPicture.asset('assets/avatar_placeholder.svg'),
                              ),
                              fit: BoxFit.cover,
                            ),
                          )),
                    ),
                    widget.eventOwner?.userRole == 1
                        ? Positioned(
                            right: 0,
                            child: SvgPicture.asset('assets/svg/hittapa-admin-mark.svg'),
                          )
                        : Positioned(
                            right: 0,
                            child: SvgPicture.asset('assets/safe_icon.svg'),
                          ),
                  ],
                ),
              ),
            ),
            Container(
                height: 100,
                child: Column(
                  children: [
                    Text(
                      remoteUid != null ? 'END' : 'WATING',
                      style: TextStyle(color: BACKGROUND_COLOR),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        _cancelCall();
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                          color: ADMIN_REQUEST_ONE_COLOR,
                        ),
                        child: SvgPicture.asset('assets/svg/phone-vertical.svg'),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
