import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:hittapa/models/location_category.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/models/venue.dart';
import 'package:hittapa/screens/auth/account_confirm_screen.dart';
import 'package:hittapa/screens/auth/create_account_screen.dart';
import 'package:hittapa/screens/auth/email_auth_screen.dart';
import 'package:hittapa/screens/auth/login_screen.dart';
import 'package:hittapa/screens/auth/profile_preview_screen.dart';
import 'package:hittapa/screens/call/caller.dart';
import 'package:hittapa/screens/call/receiver.dart';
import 'package:hittapa/screens/chatRoom/message_screen.dart';
import 'package:hittapa/screens/dashboard/covid_detail.dart';
import 'package:hittapa/screens/dashboard/filter_screen.dart';
import 'package:hittapa/screens/dashboard/menu_screen.dart';
import 'package:hittapa/screens/dashboard/search_location_screen.dart';
import 'package:hittapa/screens/dashboard/video_play.dart';
import 'package:hittapa/screens/events/category_screen.dart';
import 'package:hittapa/screens/events/check_locations_screen.dart';
import 'package:hittapa/screens/events/covid_restriction.dart';
import 'package:hittapa/screens/events/event_attendee_screen.dart';
import 'package:hittapa/screens/events/event_date_screen.dart';
import 'package:hittapa/screens/events/new_event_screen.dart';
import 'package:hittapa/screens/events/search_result_screen.dart';
import 'package:hittapa/screens/events/subcategory_confirm_screen.dart';
import 'package:hittapa/screens/intro/workflow_screen.dart';
import 'package:hittapa/screens/location/location_detail_screen.dart';
import 'package:hittapa/screens/location/my_location_screen.dart';
import 'package:hittapa/screens/location/new_location_screen.dart';
import 'package:hittapa/screens/main/birthday_screen.dart';
import 'package:hittapa/screens/main/map_splash_screen.dart';
import 'package:hittapa/screens/main/privacy_screen.dart';
import 'package:hittapa/screens/main/splash_screen.dart';
import 'package:hittapa/screens/profile/about_us_screen.dart';
import 'package:hittapa/screens/profile/edit_profile_screen.dart';
import 'package:hittapa/screens/profile/pick_user_location.dart';
import 'package:hittapa/screens/profile/profile_screen.dart';
import 'package:hittapa/screens/profile/setting_screen.dart';
import 'package:hittapa/screens/profile/setting_screen_logout.dart';
import 'package:hittapa/screens/screens.dart';

import 'package:hittapa/screens/events/map_screen_new.dart';

import 'package:hittapa/screens/auth/forgot_password.dart';
import 'package:hittapa/screens/auth/reset_password.dart';
import 'package:hittapa/widgets/datetime_picker.dart';

import 'routes.dart';

navigateToCreateAccountScreen(BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => CreateAccountScreen()));
}

navigateToEmailCheckScreen(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => new EmailAuthScreen()));
}

navigateToWorkFlowScreen(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => new WorkFlowScreen(
            onFinished: () {},
          )));
}

navigateToRegisterScreen(BuildContext context, String email) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => new CreateEmailAccountScreen(
            email: email,
          )));
}

navigateToLoginScreen(BuildContext context, String email) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => new LoginScreen(
            email: email,
          )));
}

navigateToForgotPasswordScreen(BuildContext context, String email) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => new ForgotPasswordScreen(
            email: email,
          )));
}

navigateToResetPasswordScreen(BuildContext context, String email) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => new ResetPasswordScreen(
            email: email,
          )));
}

navigateToPreviewProfileScreen(BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => ProfilePreviewScreen()));
}

navigateToSplashScreen(BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SplashScreen()));
}

// navigateToTestUserLogged(BuildContext context) {
//   Navigator.of(context).pushReplacement(
//       MaterialPageRoute(builder: (BuildContext context) => TestUserLogged()));
// }

navigateToAccountConfirmScreen(BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => AccountConfirmationScreen()));
}

navigateToMapSplashScreen(BuildContext context, double lon, double lat) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (BuildContext context) => MapSplashScreen(
            latitude: lat,
            longitude: lon,
          )));
}

navigateToDashboardScreen(BuildContext context, UserModel user, {int position, int activies}) {
  if (position == null) {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => DashboardScreen(user: user)), (Route<dynamic> route) => false);
  } else {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DashboardScreen(currentPage: position, activies: activies, user: user)));
  }
}

navigateToCategoryScreen(BuildContext context, {VenueModel location, AppState appstate, int pathIndex}) {
  if (pathIndex == 1)
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CategoryScreen(venue: location, appstate: appstate)));
  else
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => CategoryScreen(venue: location, appstate: appstate)));
}

navigateToNewEventScreen(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => NewEventScreen()));
}

Future<dynamic> navigateToMapScreen(BuildContext context, EventModel event, String userId) {
  return Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => MapScreen(
            event: event,
            userId: userId,
          )));
}

Future<dynamic> navigateToBirthDayScreen(BuildContext context, DateTime birthday) {
  return Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => BirthDayScreen(birthday: birthday)));
}

navigateToMenuScreen(BuildContext context) {
  return Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => MenuScreen()));
}

Future<dynamic> navigateToFilterScreen(BuildContext context) {
  return Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => FilterScreen()));
}

navigateToProfileScreen(BuildContext context) {
  return Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ProfileScreen()));
}

navigateToDetailScreen(BuildContext context, EventModel event) {
  return Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => EventDetailScreen(
            event: event,
          )));
}

navigateToVideoPlayScreen(BuildContext context, VideoModel currentVideo) {
  return Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => VideoPlay(
            currentVideo: currentVideo,
          )));
}

navigateToEventDateScreen({
  BuildContext context,
  Function onDiscard,
  DateTime startTime,
  DateTime endTime,
  bool isFlexibleDate,
  bool isFlexibleStartTime,
  bool isFlexibleEndTime,
  OnDateTimeChanged onDateTimeChanged,
}) {
  return Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => EventDateScreen(
            onDiscard: onDiscard,
            startTime: startTime,
            endTime: endTime,
            isFlexibleDate: isFlexibleDate,
            isFlexibleStartTime: isFlexibleStartTime,
            isFlexibleEndTime: isFlexibleEndTime,
          )));
}

navigateToEventAttendeeScreen({BuildContext context, Function onDiscard, Function onAdd, EventModel event}) {
  return Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => EventAttendeeScreen(onDiscard: onDiscard, onAdd: onAdd, event: event)));
}

navigateToSettingScreen(BuildContext context) {
  return Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SettingScreen()));
}

navigateToSettingScreenLogout(BuildContext context) {
  return Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SettingScreenLogout()));
}

Future<UserModel> navigateToEditProfile(BuildContext context, UserModel user) {
  return Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => EditProfileScreen(user)));
}

Future<dynamic> navigateToMessageScreen(BuildContext context, EventModel event) {
  return Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => MessageScreen(event: event)));
}

Future<Address> navigateToLocationPickerScreen(BuildContext context) {
  return Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => PickUserLocationScreen()));
}

Future<bool> navigateToCallerScreen(BuildContext context, String channelName, EventModel event, UserModel eventOwner) {
  return Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CallScreen(channelName: channelName, event: event, eventOwner: eventOwner)));
}

Future<bool> navigateToReceiverScreen(BuildContext context, String channelName, String callerId, String receiverId) {
  return Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ReceiverScreen(channelName: channelName, callerId: callerId, receiverId: receiverId)));
}

navigateToCheckLocationScreen(BuildContext context, double lat, double lng, bool accepted, String name, String address, EventModel event) {
  return Navigator.of(context)
      .push(MaterialPageRoute(builder: (BuildContext context) => CheckLocationsScreen(latitude: lat, longitude: lng, isAccepted: accepted, name: name, address: address, event: event)));
}

Future<dynamic> navigateToSearchLocationScreen(BuildContext context, double lat, double lng, LocationModel address) {
  return Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => SearchLocationScreen(
            latitude: lat,
            longitude: lng,
            address: address,
          )));
}

navigateToPrivacyScreen(BuildContext context) {
  return Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => PrivacyScreen()));
}

navigateToNewLocationScreen(BuildContext context) {
  return Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => NewLocationScreen()));
}

navigateToLocationDetailScreen(BuildContext context, VenueModel location, {List<File> images, File logo, List<LocationCategoryModel> categories, List<VenueOpenTimesModel> openTimes}) {
  return Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => LocationDetailScreen(
            location: location,
            images: images,
            logo: logo,
            categories: categories,
            openTimes: openTimes,
          )));
}

navigateToCovidDetailScreen(BuildContext context, CovidModel covidModel) {
  return Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => CovidDetailScreen(
            covidModel: covidModel,
          )));
}

navigateToAboutUsScreen(BuildContext context) {
  return Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AboutUsScreen()));
}

navigateToMyLocationScreen(BuildContext context) {
  return Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => MyLocationScreen()));
}

navigateToLocationSearchResultScreen(BuildContext context, double lat, double lng) {
  return Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => SearchByLocationResultScreen(
            lat: lat,
            lng: lng,
          )));
}

navigateToSubCategoryConfirmScreen(BuildContext context, {EventSubcategoryModel subcategory, String router}) {
  return Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => SubCategoryConfirmScreen(
            subcategory: subcategory,
            router: router,
          )));
}

navigateToCovidRestrictionScreen(BuildContext context, {EventSubcategoryModel subcategory, String router}) {
  return Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => CovidRestrictionScreen(
            subcategory: subcategory,
            router: router,
          )));
}
