import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/actions/user.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/utils/enumHelpers.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/global_export.dart';

import '../../global.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return StoreConnector<AppState, dynamic>(
      converter: (store) => store,
      builder: (context, store){
        AppState state = store.state;
        var user = state.user;
        var backgroundImage = state.backgroundImage;
        return Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: backgroundImage!=null && backgroundImage.image!=null ? Image.network(backgroundImage.image).image : Image.asset('assets/profile.jpeg').image,
                  fit: BoxFit.cover)),
          child: Scaffold(
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        margin: EdgeInsets.symmetric(
                            vertical: 40, horizontal: 17),
                        child: CircleAvatar(
                          backgroundImage:
                          CachedNetworkImageProvider(user.avatar ?? DEFAULT_AVATAR),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            user.username,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${user.birthday != null ? ageCalculate(user.birthday) : ""}, ${enumHelper.enum2str(user.gender).toUpperCase()}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      IconButton(
                        icon: SvgPicture.asset('assets/edit_icon.svg'),
                        onPressed: () => navigateToEditProfile(context, user)
                            .then((value) {
                          store.dispatch(updateUser(value));
                        }),
                      )
                    ],
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 23, vertical: 7),
                    child: Text(
                      backgroundImage!=null && backgroundImage.title!=null ? backgroundImage.title : LocaleKeys.setting_hiking.tr(),
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    height: 76,
                    margin: EdgeInsets.symmetric(horizontal: 23),
                    child: Text(
                      backgroundImage!=null && backgroundImage.description!=null ? backgroundImage.description : LocaleKeys.setting_let_go.tr(),
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
