import 'dart:math';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hittapa/utils/language.dart';
import 'package:hittapa/config.dart' as config;
import 'package:flushbar/flushbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hittapa/actions/providerAction.dart';
import 'package:hittapa/models/location_category.dart';
import 'package:hittapa/models/location_requirement.dart';
import 'package:hittapa/models/user.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/utils/routes.dart';
import 'package:intl/intl.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hittapa/services/node_service.dart';

import 'models/event.dart';
import 'models/models.dart';

String deviceToken = '';
String apiToken = '';

Injector injector = new Injector();

List categories = [];
List<LocationCategoryModel> locationCategories = [];
// colors
BuildContext globalContext;
const FACEBOOK_COLOR = Color(0xFF3B5998);
const GOOGLE_COLOR = Color(0xFF657795);
const GRADIENT_COLOR_ONE = Color(0xFFFF3001);
const GRADIENT_COLOR_TWO = Color(0xFFFF6500);
const GRAY_COLOR = Color(0xFFDDDDDD);
const BORDER_COLOR = Color(0xFF657795);
const HINT_COLOR = Color(0x64657795);
const DART_TEXT_COLOR = Color(0xFF2B2B2B);
const TITLE_TEXT_COLOR = Color(0xFF393939);
const CIRCLE_AVATAR_COLOR = Color(0xFFD8D8D8);
const NAVIGATION_ACTIVE_COLOR = Color(0xFF88898D);
const NAVIGATION_NORMAL_COLOR = Color(0xFFB4B5B7);
const NAVIGATION_NORMAL_TEXT_COLOR = Color(0xFF1F1F1F);
const BACKGROUND_COLOR = Color(0xFFF9FAFC);
const SEPARATOR_COLOR = Color(0xFF979797);
const SHADOW_COLOR = Color(0xFF979797);
const CARD_BORDER_COLOR = Color(0xFFC8CFD9);
const CARD_BACKGROUND_COLOR = Color(0xFFF4F5F7);
const CHECKED_COLOR = Color(0xFF02BC5C);
const REMINDER_COLOR = Color(0xFFFF3201);
const UNREAD_COLOR = Color(0x20FD5805);
const PRIMARY_COLOR = Color(0xFF007AFF);
const MESSAGE_BACKGROUND_COLOR = Color(0xFFF7F7F7);
const SEPARATOR2_COLOR = Color(0xFFEAECF3);
const PENDING_COLOR = Color(0xFFE7DE6C);
const LOCATION_LABEL_COLOR = Color(0xFF5872DB);
const EVENT_BACKGROUND_COLOR = Color(0xFFECF5FC);
const LOCATION_LABEL_BACKGROUND_COLOR = Color(0xFFBBBBBB);
const UNACCEPTED_CARD_COLOR = Color(0xFFccccff);
const LIGHTBLUE_BUTTON_COLOR = Color(0xFF00C7E6);
const BLACK_COLOR = Color(0xff000000);
const TAB_COLOR = Color(0xffD1D1D1);
const TAB_TWO_COLOR = Color(0xffffffff);
const ADMIN_REQUEST_ONE_COLOR = Color(0xFFFF5700);
const ADMIN_REQUEST_TWO_COLOR = Color(0xFF429321);

// endpoints
// const BASE_ENDPOINT = 'http://192.168.3.28:3300/api/';
// const BASE_SOCKET_ENDPOINT = 'http://192.168.3.28:3300';
const BASE_ENDPOINT = 'https://backend.hittapa.com/api/';
const BASE_SOCKET_ENDPOINT = 'https://backend.hittapa.com';
const DYNAMIC_URL = 'https://hittapa.page.link';
const AGORA_APP_ID = 'ff954d65090d4765a8c62a68835a566a';
const AGORA_APP_KEY = '2c0550a8415843938d20d352a15cda5d';
const AGORA_APP_TOKEN = '006ff954d65090d4765a8c62a68835a566aIAD2pl5IDqwhbpVmz0mEv+6Ujnthef9tNdNdxVS75znDGI9auH4AAAAAEAA3CeSjvD1RYgEAAQC8PVFi';

const ADMINMESSAGEID = "HittapaSupport";
const ADMINMESSAGEDES = "This is the message from HittaPå support team.";
const ADMINMESSAGEIMAGEURL = BASE_SOCKET_ENDPOINT + "/images/hittapa_logo.png";
const ADMINMESSAGENAME = "HittaPå";

const AUTH_LOGIN_URL = 'auth/login';
const AUTH_REGISTER_URL = 'auth/registration';
const AUTH_SOCIAL_URL = 'auth/social';
const AUTH_FORGOTPASSWORD_URL = 'auth/forgot';
const AUTH_CHECKVERIFYCODE_URL = 'auth/check_code';
const AUTH_RESETPASSWORD_URL = 'auth/reset_password';
const AUTH_EMAIL_URL = 'user/email/check';
const USER_UPDATE_URL = 'user/update';
const USER_ADD_URL = 'user/add';
const USER_UPDATE_FCMTOKEN = 'user/update/fcmToken';
const USER_GET_AGORA_TOKEN = 'user/agora/accessToken';
const USER_SEND_NOTIFICATION = 'user/send/notification';
const FILE_UPLOAD_URL = 'file/upload';
const AVATAR_UPLOAD_URL = 'file/upload/avatar';
const GET_USER_URL = 'user/get';
const POST_NEW_EVENT = 'event/create';
const POST_EVENT_LIST = 'event/events';
const POST_EVENT_ACCEPTED = 'event/events/accepted';
const POST_EVENT_PENDING = 'event/events/pending';
const POST_EVENT_STANDBY = 'event/events/standby';
const POST_EVENT_USER = 'event/events/user';
const POST_PAST_EVENT_ACCEPTED = 'event/past/events/accepted';
const POST_PAST_EVENT_USER = 'event/past/events/user';
const POST_PAST_EVENT = 'event/past/events';
const GET_EVENT_LOCATION = 'event/events/location';
const GET_EVENT = 'event/event';
const PATCH_EVENT_UPDATE = 'event/update';
const POST_USERS_ACCEPTED = 'event/users/accepted';
const POST_NEW_LOCATION = 'location/create';
const POST_LOCATION_LIST = 'location/gets';
const GET_LOCATION_CATEGORY_URL = 'location/categories';
const POST_USER_REPORT = 'report/create';
const POST_USER_REPORT_BEHAVIOR = 'report/create/behavior';
const POST_USERS_GET = 'user/gets';
const GET_CATEGORY = 'category/get';
const GET_BACKGROUND = 'background/get';
const POST_COVID_LIST = 'covid/gets';
const POST_MESSAGE = 'user/message';
const POST_SEND_EVENT_MESSAGE = 'event/message';

const GET_CURRENT_USER_URL = 'users';
const GET_CATEGORIES = 'event/category';
const GET_SUBCATEGORIES = 'event/subcategories';
const GET_REQUIREMENTS = 'event/requirements';
const GET_POST_REQUIREMENTS = 'event/post_requirement';
const POST_JOIN_EVENT_REQUEST = 'event/applicant';
const GET_UPCOMING_URL = 'event/activities/0';
const GET_PASSED_URL = 'event/activities/1';
const GET_OLD_ACTIVITIES_URL = 'event/activities/2';
const GET_CHAT_FRIENDS_URL = 'event/chat_friends';
const PUT_ACCEPT_APPLICANT_URL = 'event/applicant_accept';
const GET_NOTIFICATION_URL = 'user/notifications';
const POST_EVENT_FEEDBACK_URL = 'event/feedback';
const GET_LOCATION_LIST_URL = 'location/location';
const GET_MY_LOCATIONS_URL = 'location/my_locations';
const GET_MESSAGE_HISTORY_URL = 'message/load_messages';
const APPLICANT_WITHDRAW_URL = 'event/applicant_withdraw';
const FACEBOOK_AUTH_URL = 'auth/facebook';
const GOOGLE_AUTH_URL = 'auth/google';
const FILTER_URL = 'event.ownerId_filter';
const SEARCH_BY_LOCATION_URL = 'event/search_by_location';

const TEST_EVENT_COLLECTION = 'test_events';
const DEFAULT_AVATAR = 'https://firebasestorage.googleapis.com/v0/b/hittapa-1551774042820.appspot.com/o/profile%2Fdefault-avatar.jpg?alt=media&token=378195c0-1404-452d-acac-04ee49a76e87';

// global constants
const tempos = <String>['Slow', 'Normal', 'Fast'];

const RATING_STRING = <String>['', '☹', '🙁', '😐', '🙂', '🤩'];

const REPORT_OPTION = <String>['User sexually harrising', 'User is advertising', 'User is demanding for money'];

const FEEDBACK_TYPE = <String>['', '', 'It was fun', 'It was interesting', 'It was amazing'];

const driverLisence = <String>['Cat. A', 'Cat. B', 'Cat. C', 'Cat. D'];

// ignore: non_constant_identifier_names
EventModel AdminEvent = new EventModel(id: ADMINMESSAGEID, imageUrl: ADMINMESSAGEIMAGEURL, name: ADMINMESSAGENAME, description: ADMINMESSAGEDES, participantsAccepted: [], updatedAtDT: DateTime.now());

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// global function to convert from degrees to Radians
double degreesToRadians(double degrees) {
  return degrees * pi / 180;
}

// global distance calculation method from coordinates
Future<int> distanceInKmBetweenEarthCoordinates(double lat1, double lon1, double lat2, double lon2) async {
  if (lat1 == null || lon1 == null || lat2 == null || lon2 == null) return 0;
  return (Geolocator.distanceBetween(lat1, lon1, lat2, lon2)).toInt();
}

// global function to get short gender character
String getGenderCharacter(GenderType type) {
  if (type.toString().split('.').length > 1) return type.toString().split(".")[1].substring(0, 1).toUpperCase();
  return 'B';
}

// 1km to degree (longitue and latitude)
const DegreeToKilo = 0.009009009;

String getMonthName(int n) {
  switch (n) {
    case 1:
      return 'January';
    case 2:
      return 'February';
    case 3:
      return 'March';
    case 4:
      return 'April';
    case 5:
      return 'May';
    case 6:
      return 'June';
    case 7:
      return 'July';
    case 8:
      return 'August';
    case 9:
      return 'September';
    case 10:
      return 'October';
    case 11:
      return 'November';
    case 12:
      return 'December';
    default:
      return '';
  }
}

getDateTimeString(DateTime date) {
  DateTime now = DateTime.now();
  int diff = now.year * now.month * now.day - date.year * date.month * date.day;
  String _date = '';
  if (diff == 0) {
    _date = 'TODAY';
  } else if (diff == 1) {
    _date = 'YESTERDAY';
  } else if (diff == -1) {
    _date = 'TOMORROW';
  } else {
    _date = DateFormat('MMM d').format(date);
  }
  return '$_date, ${DateFormat('hh:mm').format(date)} hr';
}

getDateTimeStringAgo(DateTime date) {
  DateTime now = DateTime.now();
  int diff = now.difference(date).inDays;
  if (diff <= 2) {
    int _hours = now.hour - date.hour;
    _hours += diff * 24;
    int _mins = now.minute - date.minute;
    if (_mins < 0) {
      _hours -= 1;
      _mins += 60;
    }
    if (_hours == 0) {
      if (_mins == 0)
        return 'A few seconds ago';
      else
        return '${_mins.toString()}m ago';
    } else {
      if (_mins == 0)
        return '${_hours.toString()}hr ago';
      else
        return '${_hours.toString()}hr ${_mins.toString()}m ago';
    }
  } else {
    String _date = '';
    if (diff == 0) {
      _date = 'TODAY';
    } else if (diff == 1) {
      _date = 'YESTERDAY';
    } else if (diff == -1) {
      _date = 'TOMORROW';
    } else {
      _date = DateFormat('d MMM yyyy').format(date);
    }
    return '$_date';
  }
}

getEventCategoriesString(List<LocationCategoryModel> categories) {
  String result = '';
  for (int i = 0; i < categories.length; i++) {
    result += categories[i].name;
    result += ', ';
  }
  return result;
}

getCategoriesString(List<LocationRequirement> categories) {
  String result = '';
  for (int i = 0; i < categories.length; i++) {
    result += categories[i].description;
    result += ', ';
  }
  return result;
}

// global function to convert from SVG file to bitmap object
Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(BuildContext context, String assetName) async {
  String svgString = await DefaultAssetBundle.of(context).loadString(assetName);
  DrawableRoot drawableRoot = await svg.fromSvgString(svgString, null);
  ui.Picture picture = drawableRoot.toPicture(size: Size(152, 192));
  ui.Image image = await picture.toImage(152, 192);
  ByteData bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
}

Future onSelectNotification(String payload) async {
  if (payload != null) {
    debugPrint('notification payload: ' + payload);
    var index = payload.split("#")[0];
    var indexId = payload.split("#")[1];

    if (indexId == ADMINMESSAGEID) {
      navigateToMessageScreen(globalContext, AdminEvent);
    } else {
      var _result = await NodeService().getEventById(indexId);
      if (_result != null && _result['data'] != null) {
        EventModel _event = EventModel.fromJson(_result['data']);
        if (index == 'event') {
          navigateToDetailScreen(globalContext, _event);
        } else {
          navigateToMessageScreen(globalContext, _event);
        }
      }
    }
  }
}

Widget onFlashBar(title, body, payload) {
  return Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
    reverseAnimationCurve: Curves.decelerate,
    forwardAnimationCurve: Curves.elasticOut,
    onTap: (d) async {
      d.dismiss();
      onSelectNotification(payload);
    },
    backgroundColor: Colors.red,
    boxShadows: [BoxShadow(color: Colors.blue[800], offset: Offset(0.0, 2.0), blurRadius: 3.0)],
    backgroundGradient: LinearGradient(colors: [Colors.blueGrey, Colors.black]),
    isDismissible: false,
    duration: Duration(seconds: 5),
    icon: Icon(
      Icons.notification_important,
      color: Colors.greenAccent,
    ),
    onStatusChanged: (status) {
      if (status == FlushbarStatus.IS_APPEARING) {
        print("clear");
      }
    },
    showProgressIndicator: true,
    progressIndicatorBackgroundColor: Colors.blueGrey,
    titleText: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.yellow[600], fontFamily: "ShadowsIntoLightTwo"),
    ),
    messageText: Text(
      body,
      style: TextStyle(fontSize: 18.0, color: Colors.green, fontFamily: "ShadowsIntoLightTwo"),
    ),
  )..show(globalContext);
}

Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
  showDialog(
    context: globalContext,
    useSafeArea: false,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text('Ok'),
          onPressed: () async {
            Navigator.of(context, rootNavigator: true).pop();
          },
        )
      ],
    ),
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("@@@@@Handling a background message: ${message.data}");
  print("@@@@@Handling a background message: ${message.notification}");
  print("@@@@@Handling a background message: ${message.notification?.title}");
}

setFirebaseNotification() async {
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');
  final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage message) {
    print('@@@@@ message detail from getinitial message');
    print(message);
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification notification = message.notification;
    AndroidNotification android = message.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(channel.id, channel.name, channel.description, icon: android.smallIcon),
        ),
        payload: message.data['title'] == null ? '' : message.data['title'] + "#" + message.data['body'],
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    String payload = message.data['title'] + "#" + message.data['body'];
    onSelectNotification(payload);
  });
}

localNotification() async {
  var initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
}

raiseLocalNotification(String title, String body, String dataTitle, String dataBody) async {
  if (body.contains("#")) {
    body = body.split("#")[0];
  }

  var payload = dataTitle + '#' + dataBody;

  var androidPlatformChannelSpecifics =
      AndroidNotificationDetails('hittapa_notification', 'hittapa_notification', 'hittapa_notification', importance: Importance.max, priority: Priority.high, ticker: 'ticker');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics, payload: payload);
}

Future<void> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['notification'];
    raiseLocalNotification(data['title'], data['body'], message['data']['title'], message['data']['body']);
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    // final dynamic notification = message['notification'];
  }
  return null;
  // Or do other work.
}

// ignore: non_constant_identifier_names
Widget AddEventButton(BuildContext context, AppState state) {
  return Builder(builder: (context) {
    final _provider = Provider.of<IsScroller>(context);
    return InkWell(
      onTap: () {
        navigateToCategoryScreen(context, appstate: state, pathIndex: 1);
        // navigateToSubCategoryConfirmScreen(context, subcategory: null, router: Routes.NEW_EVENT);
      },
      child: _provider.isTop
          ? Container(
              decoration: BoxDecoration(
                color: Color(0x30000000),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 3, color: Colors.white),
              ),
              width: MediaQuery.of(context).size.width / 2 - 25,
              height: 35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Create event",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Image.asset(
                    'assets/images/plus.png',
                    width: 28,
                    height: 28,
                    color: Colors.white,
                  ),
                ],
              ))
          : Container(
              decoration: BoxDecoration(color: Color(0x30000000), borderRadius: BorderRadius.circular(50)),
              width: 35,
              height: 35,
              child: Image.asset(
                'assets/images/plus.png',
                width: 25,
                height: 25,
                color: Colors.white,
              ),
            ),
    );
  });
}

List<Locale> getSupportedLanguages() {
  final List<Locale> localeList = <Locale>[];
  for (final Language lang in config.hittaPaSupportedLanguageList) {
    localeList.add(Locale(lang.languageCode, lang.countryCode));
  }
  print('Loaded Languages');
  return localeList;
}

Locale getdefaulLanguage(languages) {
  Locale _defaultLocale = config.defaultLanguage.toLocale();
  for (final Language lang in config.hittaPaSupportedLanguageList) {
    if (lang.languageCode == languages[0]) {
      _defaultLocale = lang.toLocale();
      break;
    }
  }
  return _defaultLocale;
}

launchURL(String _link) async {
  print(_link);

  String url = _link.contains('http') ? _link : 'https://' + _link;
  print(url);
  await launch(url);
}

hittaPaToast(String msg, int msgType) {
  if (msg == null || msg == "" || msgType == null) return;
  switch (msgType) {
    case 0:
      Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
      );
      break;
    default:
      Fluttertoast.showToast(
        msg: msg,
        fontSize: 12,
        toastLength: Toast.LENGTH_LONG,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
      );
  }
}

Widget eventOwnerWidget(UserModel eventOwner, bool isBorderColor, bool isBlur) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        width: 50,
        height: 50,
        margin: EdgeInsets.only(left: 16),
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                boxShadow: [
                  new BoxShadow(
                    color: GRAY_COLOR,
                    blurRadius: isBlur ? 10.0 : 0,
                  ),
                ],
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  child: Container(
                    child: CachedNetworkImage(
                      width: 50,
                      height: 50,
                      imageUrl: eventOwner?.avatar ?? DEFAULT_AVATAR,
                      placeholder: (context, url) => Center(
                        child: SvgPicture.asset(
                          'assets/avatar_placeholder.svg',
                          width: 50,
                          height: 50,
                        ),
                      ),
                      errorWidget: (context, url, err) => Center(
                        child: SvgPicture.asset('assets/avatar_placeholder.svg'),
                      ),
                      fit: BoxFit.cover,
                    ),
                  )),
            ),
            eventOwner?.userRole == 1
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
      Container(
        margin: EdgeInsets.only(left: 0, top: 30),
        width: 130,
        child: Text(
          ' ${eventOwner?.username} ${eventOwner?.birthday != null ? ageCalculate(eventOwner.birthday) : ""}${getGenderCharacter(eventOwner?.gender)}',
          style: TextStyle(fontSize: 14, color: isBorderColor ? CIRCLE_AVATAR_COLOR : NAVIGATION_NORMAL_TEXT_COLOR, fontWeight: FontWeight.w500),
        ),
      )
    ],
  );
}

ageCalculate(DateTime birthday) {
  if (birthday != null || birthday is DateTime) {
    int age = DateTime.now().year - birthday.year;
    if (DateTime.now().month < birthday.month) {
      age = age - 1;
    }
    if (DateTime.now().month == birthday.month && DateTime.now().day < birthday.day) {
      age = age - 1;
    }
    return age;
  } else {
    return null;
  }
}

Widget eventOwnerWidgetOnImage(UserModel eventOwner, bool isBorderColor, bool isBlur) {
  return Container(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(right: 5),
          child: Text(
            '${eventOwner?.username}, ${ageCalculate(eventOwner?.birthday)}${getGenderCharacter(eventOwner?.gender)}',
            style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
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
                      blurRadius: isBlur ? 10.0 : 0,
                    ),
                  ],
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    child: Container(
                      child: CachedNetworkImage(
                        width: 80,
                        height: 80,
                        imageUrl: eventOwner?.avatar ?? DEFAULT_AVATAR,
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
              eventOwner?.userRole == 1
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
      ],
    ),
  );
}

Widget eventOwnerImageOnBottom(UserModel eventOwner) {
  return Container(
    child: Column(
      children: [
        Container(
          width: 50,
          height: 50,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  boxShadow: [
                    new BoxShadow(
                      color: GRAY_COLOR,
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child: Container(
                      child: CachedNetworkImage(
                        width: 50,
                        height: 50,
                        imageUrl: eventOwner?.avatar ?? DEFAULT_AVATAR,
                        placeholder: (context, url) => Center(
                          child: SvgPicture.asset(
                            'assets/avatar_placeholder.svg',
                            width: 50,
                            height: 50,
                          ),
                        ),
                        errorWidget: (context, url, err) => Center(
                          child: SvgPicture.asset('assets/avatar_placeholder.svg'),
                        ),
                        fit: BoxFit.cover,
                      ),
                    )),
              ),
              eventOwner?.userRole == 1
                  ? Positioned(
                      right: 0,
                      bottom: 0,
                      child: SvgPicture.asset('assets/svg/hittapa-admin-mark.svg'),
                    )
                  : Positioned(
                      right: 0,
                      bottom: 0,
                      child: SvgPicture.asset('assets/safe_icon.svg'),
                    ),
            ],
          ),
        ),
      ],
    ),
  );
}

Future<String> getDistance(EventModel event) async {
  Position _p = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  return ((await distanceInKmBetweenEarthCoordinates(_p.latitude, _p.longitude, event.location.coordinates[0], event.location.coordinates[1])) / 1000).toStringAsFixed(2);
}
