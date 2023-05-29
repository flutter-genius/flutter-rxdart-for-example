import 'package:hittapa/services/http_service.dart';

import 'package:hittapa/global.dart';

class NodeService {

  /// create event api
  Future<dynamic> createEvent(dynamic event, String token) async {
    try{
      Map _result = await requestAuthPost(POST_NEW_EVENT, event, token);
      return _result;
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  /// get events by filter
  Future<dynamic> getEvents(dynamic event) async {
    try{
      var _result = await requestAuthPost(POST_EVENT_LIST, event, apiToken) ;
      return _result;
    }catch(e){
      print(e);
      return null;
    }
  }

  /// get accepted events
  Future<dynamic> getEventsAccepted(dynamic event) async {
    try{
      var _result = await requestAuthPost(POST_EVENT_ACCEPTED, event, apiToken) ;
      return _result;
    }catch(e){
      print(e);
      return null;
    }
  }

  /// get pending events
  Future<dynamic> getEventsPending(dynamic event) async {
    try{
      var _result = await requestAuthPost(POST_EVENT_PENDING, event, apiToken) ;
      return _result;
    }catch(e){
      print(e);
      return null;
    }
  }

  /// get standby events
  Future<dynamic> getEventsStandBy(dynamic event) async {
    try{
      var _result = await requestAuthPost(POST_EVENT_STANDBY, event, apiToken) ;
      return _result;
    }catch(e){
      print(e);
      return null;
    }
  }

  /// get user's events
  Future<dynamic> getEventsByUser(dynamic event) async {
    try{
      var _result = await requestAuthPost(POST_EVENT_USER, event, apiToken) ;
      return _result;
    }catch(e){
      print(e);
      return null;
    }
  }

  /// get past accepted events
  Future<dynamic> getPastEventsAccepted(dynamic event) async {
    try{
      var _result = await requestAuthPost(POST_PAST_EVENT_ACCEPTED, event, apiToken) ;
      return _result;
    }catch(e){
      print(e);
      return null;
    }
  }

  /// get user's past events
  Future<dynamic> getPastEventsByUser(dynamic event) async {
    try{
      var _result = await requestAuthPost(POST_PAST_EVENT_USER, event, apiToken) ;
      return _result;
    }catch(e){
      print(e);
      return null;
    }
  }

  /// get past events
  Future<dynamic> pastEvents(dynamic event) async {
    try{
      var _result = await requestAuthPost(POST_PAST_EVENT, event, apiToken) ;
      return _result;
    }catch(e){
      print(e);
      return null;
    }
  }

  /// get events by location
  Future<dynamic> getEventsByLocation(String locationId) async {
    try{
      var _result = await requestAuthGet(GET_EVENT_LOCATION, locationId, apiToken) ;
      return _result;
    }catch(e){
      print(e);
      return null;
    }
  }

  /// get event by event id
  Future<dynamic> getEventById(String eventId) async {
    try{
      var _result = await requestAuthGet(GET_EVENT, eventId, apiToken) ;
      return _result;
    }catch(e){
      print(e);
      return null;
    }
  }

  /// update the event
  Future<dynamic> updateEvent(dynamic event) async {
    try{
      Map _result = await requestAuthPatch(PATCH_EVENT_UPDATE, event, event['id'], apiToken);
      return _result;
    }catch(e){
      print(e);
      return null;
    }
  }

  /// get users of event accepted
  Future<dynamic> getEventsUsers(dynamic event) async {
    try{
      var _result = await requestAuthPost(POST_USERS_ACCEPTED, event, apiToken) ;
      return _result;
    }catch(e){
      print(e);
      return null;
    }
  }

  /// create location api
  Future<dynamic> createLocation(dynamic event) async {
    try{
      var _result = await requestAuthPost(POST_NEW_LOCATION, event, apiToken) ;
      return _result;
    }catch(e){
      print(e);
      return null;
    }
  }

  /// get location categories
  Future<dynamic> getLocationCategories() async {
    try{
      var _result = await requestAuthGet(GET_LOCATION_CATEGORY_URL, '', apiToken) ;
      return _result;
    }catch(e){
      print(e);
      return null;
    }
  }

  /// get locations
  Future<dynamic> getLocations(dynamic query) async {
    try{
      var _result = await requestAuthPost(POST_LOCATION_LIST, query, apiToken) ;
      return _result;
    }catch(e){
      print(e);
      return null;
    }
  }

  /// get covid informations
  Future<dynamic> getCovidInformations(dynamic query) async {
    try{
      var _result = await requestAuthPost(POST_COVID_LIST, query, apiToken) ;
      return _result;
    }catch(e){
      print(e);
      return null;
    }
  }

  /// create user report
  Future<dynamic> createReport(dynamic reportModel) async {
    try{
      var _result = await requestAuthPost(POST_USER_REPORT, reportModel, apiToken) ;
      return _result;
    }catch(e){
      print(e);
      return null;
    }
  }

  /// create user report behavior
  Future<dynamic> createReportBehavior(dynamic reportModel) async {
    try{
      var _result = await requestAuthPost(POST_USER_REPORT_BEHAVIOR, reportModel, apiToken) ;
      return _result;
    }catch(e){
      print(e);
      return null;
    }
  }

  /// get category
  Future<dynamic> getCategories() async {
    try{
      var _result = await requestUnAuthGet(GET_CATEGORY) ;
      return _result;
    }catch(e){
      print(e);
      return null;
    }
  }

  /// get users by ids
  Future<dynamic> getUsers(dynamic userlists) async {
    try{
      var _result = await requestAuthPost(POST_USERS_GET, userlists, apiToken) ;
      return _result;
    }catch(e){
      print(e);
      return null;
    }
  }

  /// send event message to the server
  Future<dynamic> sendEventMessage(dynamic data, String eventId) async {
    try{
      var _result = await requestAuthPost(POST_SEND_EVENT_MESSAGE+'?event_id='+eventId, data, apiToken) ;
      return _result;
    }catch(e){
      print(e);
      return null;
    }
  }

  /// get background data for menu
  Future<dynamic> getBackground() async {
    try{
      var _result = await requestUnAuthGet(GET_BACKGROUND);
      print(_result);
      return _result;
    }catch(e){
      print(e);
      return null;
    }
  }

  /// send welcome message
  Future<dynamic> sendMessage(Map<String, dynamic> data) async {
    try{
      var _result = await requestUnAuthPost(POST_MESSAGE, data);
      print(_result);
      return _result;
    }catch(e){
      print(e);
      return null;
    }
  }


}
