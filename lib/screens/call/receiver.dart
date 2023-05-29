import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/services/node_auth_service.dart';
import 'package:hittapa/services/node_service.dart';
import 'package:uuid/uuid.dart';

class ReceiverScreen extends StatefulWidget {
  String channelName;
  String callerId;
  String receiverId;

  ReceiverScreen({@required this.channelName, this.callerId, this.receiverId});
  @override
  _ReceiverScreenState createState() => _ReceiverScreenState();
}

class _ReceiverScreenState extends State<ReceiverScreen> {
  UserModel eventOwner, user;
  RtcEngine engine;
  Timer _timer;
  EventModel event;

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
      debugPrint("receiver ---> enableLocalAudio: $err");
    });
  }

  void switchSpeakerphone() {
    engine?.setEnableSpeakerphone(!enableSpeakerphone)?.then((value) {
      setState(() {
        enableSpeakerphone = !enableSpeakerphone;
      });
    })?.catchError((err) {
      debugPrint("receiver ---> enableSpeakerphone: $err");
    });
  }

  Future<void> switchEffect() async {
    if (playEffect) {
      engine?.stopEffect(1)?.then((value) {
        setState(() {
          playEffect = false;
        });
      })?.catchError((err) {
        debugPrint("receiver ---> stopEffect $err");
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
        debugPrint("receiver ---> playEffect $err");
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

  Future<void> acceptCall() async {
    final String callToken = await getAgoraChannelToken(widget.channelName);
    if (callToken == null) {
      // nothing will be done
      print('there is no token...');
      _cancelCall();
      return;
    }
    // Create RTC client instance
    engine = await RtcEngine.create(AGORA_APP_ID);
    // Define event handler
    engine.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (String channel, int uid, int elapsed) async {
        debugPrint('receiver ---> joinChannelSuccess $channel $uid');
        joined = true;
        startTimer();
        setState(() {});
      },
      leaveChannel: (stats) {
        debugPrint("receiver ---> leaveChannel ${stats.toJson()}");
        joined = false;
      },
      userJoined: (int uid, int elapsed) {
        debugPrint('receiver ---> userJoined $uid');
        remoteUid = uid;
        onClickAccept(user?.uid);
        if (playEffect) switchEffect();
        if (!canIncrement) canIncrement = true;
      },
      userOffline: (int uid, UserOfflineReason reason) {
        debugPrint('receiver ---> userOffline $uid');
        remoteUid = null;
        canIncrement = false;
        switchEffect();
      },
    ));
    engine.enableAudio();
    engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    engine.setClientRole(ClientRole.Broadcaster);
    await engine.joinChannel(callToken, widget.channelName, null, 0);
  }

  Future<String> getAgoraChannelToken(String channel, [String role = "subscriber"]) async {
    try {
      var _result = await NodeAuthService().getAgoraToken(widget.channelName, null);
      if (_result != null && _result['data'] != null) {
        return _result['data'];
      }
    } catch (e) {
      debugPrint("receiver ---> getAgoraChannelToken: $e");
    }
    return null;
  }

  onClickAccept(String uid) {
    List<String> _pending = event.participantsPending;
    List<String> _accepted = event.participantsAccepted;
    List<String> _standby = event.participantsStandby;

    if (uid != null && !_accepted.contains(uid)) {
      _accepted.add(uid);
      if (_accepted.length == event.maxParticipantsNo) {
        _standby = _standby + _pending;
      }
      NodeService().updateEvent(event.copyWith(participantsAccepted: _accepted, participantsPending: _pending, participantsStandby: _standby).toJson()).then((_) {});
    }
  }

  _cancelCall() async {
    await FirebaseFirestore.instance.collection('calls').doc(widget.channelName).delete();
    Navigator.of(context).pop();
  }

  _getUsers() async {
    var _result = await NodeAuthService().getUser(widget.receiverId, null);
    if (_result != null && _result['data'] != null) {
      eventOwner = UserModel.fromJson(_result['data']);
    }
    _result = await NodeAuthService().getUser(widget.callerId, null);
    if (_result != null && _result['data'] != null) {
      user = UserModel.fromJson(_result['data']);
    }
    String eventId = widget.channelName.split('_')[0];
    _result = await NodeService().getEventById(eventId);
    if (_result != null && _result['data'] != null) {
      event = EventModel.fromJson(_result['data']);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getUsers();
    _readyFirebase();
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
            joined
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
                    'INCOMING',
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
                              imageUrl: user?.avatar ?? DEFAULT_AVATAR,
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
                    user?.userRole == 1
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          joined ? 'END' : 'REJECT',
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
                            child: SvgPicture.asset('assets/svg/phone-vertical.svg', color: BACKGROUND_COLOR),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: joined ? 0 : 30,
                    ),
                    joined
                        ? Container()
                        : Column(
                            children: [
                              Text(
                                'ACCEPT',
                                style: TextStyle(color: BACKGROUND_COLOR),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  acceptCall();
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(40)),
                                    color: ADMIN_REQUEST_TWO_COLOR,
                                  ),
                                  child: SvgPicture.asset('assets/svg/phone.svg', color: BACKGROUND_COLOR),
                                ),
                              ),
                            ],
                          )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
