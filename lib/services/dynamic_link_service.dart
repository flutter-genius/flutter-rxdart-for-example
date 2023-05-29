import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/utils/navigator.dart';
import 'dart:async';
import 'package:hittapa/models/event.dart';
import 'package:hittapa/services/node_service.dart';



class DynamicLinkService {
  Future handleDynamicLinks() async {
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDeeplink(data);

    //into foreground from dynamic link logic
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLinkData) async {
        _handleDeeplink(dynamicLinkData);
      },
      onError: (OnLinkErrorException e) async {
        print('________________ dynamic link failed : ${e.message}');
      }
    );
  }

  Future<String> createDeepLink(String eventId) async{
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: DYNAMIC_URL,
      link: Uri.parse(BASE_SOCKET_ENDPOINT + '/event/$eventId?id=$eventId'),
      androidParameters: AndroidParameters(
        packageName: 'com.hittapo.hittapo',
      ),
      iosParameters: IosParameters(
        bundleId: 'com.hittapa.mobile',
        minimumVersion: '1.0.1',
        appStoreId: '1494570181',
      ),
//      googleAnalyticsParameters: GoogleAnalyticsParameters(
//        campaign: 'example-promo',
//        medium: 'social',
//        source: 'orkut',
//      ),
//      itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
//        providerToken: '123456',
//        campaignToken: 'example-promo',
//      ),
//      socialMetaTagParameters: SocialMetaTagParameters(
//        title: 'Example of a Dynamic Link',
//        description: 'This link works whether app is installed or not!',
//      ),
    );

    final Uri dynamicUrl = await parameters.buildUrl();

    return dynamicUrl.toString();
  }

  void _handleDeeplink(PendingDynamicLinkData data) async{
    final Uri  deepLink = data?.link;
    if(deepLink != null) {

      print('_handleDeepLink | deepLink : $deepLink');

      var isEvent = deepLink.pathSegments.contains('event');
      if(isEvent){
        String eventId = deepLink.queryParameters['id'];
        if(eventId != null){
          var _result = await NodeService().getEventById(eventId);
          if(_result != null && _result['data']!= null){
            EventModel _event = EventModel.fromJson(_result['data']);
            navigateToDetailScreen(globalContext, _event);
          }
        }
      } else {
        print('_there is no event data');
      }
    }
  }
}