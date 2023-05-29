import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/utils/enumHelpers.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/widgets/show_confirm_dialog.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/global_export.dart';
import 'package:hittapa/actions/user.dart';
import 'package:hittapa/utils/routes.dart';
import 'package:hittapa/screens/main/mainScreen.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    globalContext = context;

    return Container(
        child: StoreConnector<AppState, dynamic>(
            converter: (store) => store,
            builder: (context, store) {
              AppState state = store.state;
              var user = state.user;
              var backgroundImage = state.backgroundImage;
              if (user.id == null || user.uid == null) {
                return Container();
              }

              return Container(
                  padding: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: backgroundImage != null && backgroundImage.image != null ? Image.network(backgroundImage.image).image : Image.asset('assets/profile.jpeg').image, fit: BoxFit.cover)),
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text(
                        LocaleKeys.menu_menu.tr(),
                        style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w600),
                      ),
                      centerTitle: true,
                      leading: Container(),
                      elevation: 0.0,
                      backgroundColor: Colors.transparent,
                      actions: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        )
                      ],
                    ),
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          child: Stack(children: [
                            Container(
                              height: 60,
                              width: 60,
                              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 23),
                              child: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(user.avatar ?? ''),
                              ),
                            ),
                            user?.userRole == 1
                                ? Positioned(
                                    right: 15,
                                    top: 5,
                                    child: SvgPicture.asset('assets/svg/hittapa-admin-mark.svg'),
                                  )
                                : Container()
                          ]),
                          onTap: () => navigateToProfileScreen(context),
                        ),
                        GestureDetector(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 23),
                            child: Text(
                              '${user.username}, ${user?.birthday?.year == null ? "" : ageCalculate(user.birthday)}, ${enumHelper.enum2str(user.gender).toUpperCase()}',
                              style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                          ),
                          onTap: () => navigateToProfileScreen(context),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 23, vertical: 8),
                                child: Row(
                                  children: <Widget>[
                                    SvgPicture.asset('assets/about_icon.svg'),
                                    SizedBox(
                                      width: 14,
                                    ),
                                    GestureDetector(
                                      child: Text(
                                        LocaleKeys.menu_about_hittapa.tr(),
                                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                                      ),
                                      onTap: () => navigateToAboutUsScreen(context),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 23, vertical: 8),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        width: 24,
                                        height: 24,
                                        child: SvgPicture.asset(
                                          'assets/share_icon.svg',
                                        )),
                                    SizedBox(
                                      width: 14,
                                    ),
                                    GestureDetector(
                                      child: Text(
                                        LocaleKeys.menu_share.tr(),
                                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                                      ),
                                      onTap: () {
                                        FlutterShare.share(
                                          title: 'HittaPå',
                                          text: "App/Play store url",
                                          linkUrl: "App/Play store url",
                                          chooserTitle: 'HittaPå share',
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 23, vertical: 8),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        width: 24,
                                        height: 24,
                                        child: SvgPicture.asset(
                                          'assets/location_icon.svg',
                                        )),
                                    SizedBox(
                                      width: 14,
                                    ),
                                    GestureDetector(
                                      child: Text(
                                        LocaleKeys.menu_my_locations.tr(),
                                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                                      ),
                                      onTap: () => navigateToMyLocationScreen(context),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 23, vertical: 8),
                                child: GestureDetector(
                                  child: Row(
                                    children: <Widget>[
                                      SvgPicture.asset('assets/plus-circle-outline.svg'),
                                      SizedBox(
                                        width: 14,
                                      ),
                                      Text(
                                        LocaleKeys.menu_create_location.tr(),
                                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  onTap: () => navigateToNewLocationScreen(context),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 23, vertical: 8),
                                child: GestureDetector(
                                  child: Row(
                                    children: <Widget>[
                                      SvgPicture.asset('assets/settings-outline.svg'),
                                      SizedBox(
                                        width: 14,
                                      ),
                                      Text(
                                        LocaleKeys.menu_setting.tr(),
                                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  onTap: () => navigateToSettingScreen(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                final Uri _emailLaunchUri = Uri(scheme: 'mailto', path: 'smith@gmail.com', queryParameters: {'subject': 'Feedback!'});
                                print(_emailLaunchUri);
                                print(await launch(_emailLaunchUri.toString()));
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 23, vertical: 8),
                                child: Text(
                                  LocaleKeys.menu_send_feedback.tr(),
                                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 23, vertical: 8),
                              child: Text(
                                LocaleKeys.menu_help_faq.tr(),
                                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => navigateToPrivacyScreen(context),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 23, vertical: 8),
                                child: Text(
                                  LocaleKeys.menu_privacy_policy.tr(),
                                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            // GestureDetector(
                            //   onTap: () async{
                            //     logout(store, context);
                            //     // await logOut(store);
                            //     // Navigator.pushAndRemoveUntil(context,
                            //     //   MaterialPageRoute(builder: (BuildContext context) => MainScreen()),
                            //     //   ModalRoute.withName(Routes.MAIN),);
                            //   },
                            //   child: Container(
                            //     margin: const EdgeInsets.symmetric(
                            //         horizontal: 23, vertical: 8),
                            //     child: Text(
                            //       LocaleKeys.setting_logout.tr(),
                            //       style: TextStyle(
                            //           color: Colors.white,
                            //           fontSize: 15,
                            //           fontWeight: FontWeight.w600),
                            //     ),
                            //   ),
                            // ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 23, vertical: 7),
                          child: Text(
                            backgroundImage != null && backgroundImage.title != null ? backgroundImage.title : 'Hiking in Karpatia Mountains',
                            style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          height: 76,
                          margin: EdgeInsets.symmetric(horizontal: 23),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 145,
                                child: Text(
                                  backgroundImage != null && backgroundImage.description != null
                                      ? backgroundImage.description
                                      : 'Let’s go and have an awesome cycling trip together in '
                                          'the woods. Everyone is invited, so feel free to join us!\n'
                                          'You will need, obviously, your bike and some positive',
                                  style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500),
                                ),
                              ),
                              backgroundImage != null && backgroundImage.viewMore != null
                                  ? InkWell(
                                      onTap: () {
                                        if (backgroundImage != null && backgroundImage.viewMore != null) {
                                          _launchURL(backgroundImage.viewMore);
                                        }
                                      },
                                      child: Container(
                                        height: 40,
                                        padding: EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
                                        decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.all(Radius.circular(20))),
                                        child: Center(
                                          child: Text(
                                            LocaleKeys.menu_view_more.tr(),
                                            style: TextStyle(fontSize: 14, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ));
            }));
  }

  _launchURL(String _link) async {
    String url = _link.contains('http') ? _link : 'https://' + _link;
    await launch(url);
  }

  logout(Store<AppState> store, BuildContext context) async {
    await showDialog(
        context: context,
        useSafeArea: false,
        builder: (context) => ConfirmDialog(
            title: Center(
              child: Text(
                LocaleKeys.setting_logout.tr(),
                style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            firstButton: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  margin: EdgeInsets.only(left: 30),
                  child: Text(
                    LocaleKeys.global_discard.tr().toUpperCase(),
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                )),
            secondButton: InkWell(
              onTap: () async {
                navigateToSettingScreenLogout(context);
              },
              child: Container(
                padding: EdgeInsets.only(left: 30, top: 10, right: 30, bottom: 10),
                decoration: BoxDecoration(color: GRADIENT_COLOR_ONE, borderRadius: BorderRadius.all(Radius.circular(16))),
                child: Text(
                  LocaleKeys.setting_logout.tr().toUpperCase(),
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            icon: Container(),
            yourWidget: Column(
              children: <Widget>[
                Center(
                  child: Text(
                    LocaleKeys.create_event_we_value_your_opinion.tr(),
                    style: TextStyle(color: Colors.white, fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )));
  }
}
