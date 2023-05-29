import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/event.dart';
import 'package:hittapa/utils/routes.dart';
import 'package:intl/intl.dart';
import 'package:hittapa/global_export.dart';

class EventListTile extends StatelessWidget {
  final EventModel event;

  EventListTile(this.event);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.only(left: 14),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          side: BorderSide(color: CARD_BORDER_COLOR)),
      onPressed: () => Navigator.pushNamed(context, Routes.EVENT_DETAIL,
          arguments: {"eventId": event}),
      child: Container(
        height: 100,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      event.name,
                      style: TextStyle(
                          fontSize: 17,
                          color: NAVIGATION_NORMAL_TEXT_COLOR,
                          fontWeight: FontWeight.w600),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 9),
                      child: Row(
                        children: <Widget>[
                          SvgPicture.asset(
                            'assets/calendar-outline.svg',
                            width: 16,
                          ),
                          SizedBox(
                            width: 9,
                          ),
                          Text(
                            '${event.isFlexibleDate ? 'Any date' : ''} '
                            '${DateFormat('${event.isFlexibleDate ? '' : 'd MMM, '}'
                                '${event.isFlexibleStartTime ? '' : 'HH:mm'}').format(event.startDT)} hr'
                            '${(event.isFlexibleDate && event.isFlexibleStartTime) ? ' and time' : event.isFlexibleStartTime ? 'Any time' : ''}',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: BORDER_COLOR),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/group_icon.svg',
                          width: 16,
                          color: BORDER_COLOR,
                        ),
                        SizedBox(
                          width: 9,
                        ),
                        Text(
                          '${(event.participantsAccepted ?? []).length} ' + LocaleKeys.global_people.tr(),
                          style: TextStyle(
                              fontSize: 13,
                              color: BORDER_COLOR,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: 120,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    right: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: CachedNetworkImage(
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        imageUrl: event.thumbnail ?? '',
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, err) => Center(
                          child: Center(
                            child: Icon(Icons.error_outline),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 30,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: CachedNetworkImage(
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        imageUrl: event.ownerImageUrl ?? '',
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, err) => Center(
                          child: Center(
                            child: Icon(Icons.error_outline),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
