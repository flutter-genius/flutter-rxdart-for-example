import 'package:flutter/foundation.dart';
import 'package:hittapa/models/post_requirement.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/services/node_service.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

const _debug = true; // || debug;

ThunkAction<AppState> createNewEvent({
  VenueModel venue,
  EventCategoryModel category,
  EventSubcategoryModel subcategory,
  bool isAdminEvent,
}) {
  print('@@@@@ is admin event value: ');
  print(isAdminEvent);
  return (Store<AppState> store) async {
    var dispatch = store.dispatch;
    dispatch(CreateNewEvent());
    dispatch(SetEventCategory(category, subcategory, isAdminEvent));
    dispatch(SetEventOwner());
    dispatch(SetEventRequirements(
        requirements: subcategory.requirements
            .map((e) => PostRequirement(
                  requirementId: e,
                  status: true,
                ))
            .toList()));
    if (venue != null) {
      dispatch(SetEventVenue(venue));
    }
  };
}

saveNewEventToFB({
  @required Store<AppState> store,
  @required String thumbnail,
  @required List<String> imageUrls,
  @required Function onSuccess,
  @required Function onFail,
}) async {
  if (_debug) print("saveEventToFB");
  String apiToken = store.state.user.apiToken;
  EventModel event =
      store.state.newEvent.copyWith(createdAtDT: DateTime.now(), updatedAtDT: DateTime.now(), thumbnail: thumbnail ?? store.state.newEvent.thumbnail, imageUrls: imageUrls, imageUrl: imageUrls[0]);

  var _result = await NodeService().createEvent(event.toFB(), apiToken);
  if (_result != null && _result['data'] != null) {
    store.dispatch(EventSavedToFB(event.copyWith(id: _result['data']['_id'])));
    onSuccess();
  } else {
    onFail('failed to create event');
  }
}

class EventSavedToFB {
  EventModel event;

  EventSavedToFB(this.event);

  reducer(AppState appState) {
    return appState.copyWith(
      newEvent: null,
    );
  }
}

class CreateNewEvent {
  CreateNewEvent();

  reducer(AppState appState) {
    return appState.copyWith(
      newEvent: EventModel.initial(),
    );
  }
}

class SetEventLocation {
  final LocationModel location;

  SetEventLocation(this.location);

  reducer(AppState appState) {
    // if venue is set, then location is tied to the venue and shouldn't be changed
    if (appState.newEvent.venueId != null) {
      return appState;
    }
    return appState.copyWith(
      newEvent: appState.newEvent.copyWith(location: location),
    );
  }
}

class SetEventVenue {
  final VenueModel venue;

  SetEventVenue(this.venue);

  reducer(AppState appState) {
    return appState.copyWith(
      newEvent: appState.newEvent.copyWith(
        venueId: venue.id,
        location: venue.location,
        imageUrls: [...appState.newEvent.imageUrls, ...venue.imageUrls],
      ),
    );
  }
}

class SetEventCategory {
  final EventCategoryModel category;
  final EventSubcategoryModel subcategory;
  final bool isAdminEvent;

  SetEventCategory(this.category, this.subcategory, this.isAdminEvent);

  reducer(AppState appState) {
    List<String> _list = [], listNames = [];
    for (int i = 0; i < subcategory.imageLists.length; i++) {
      _list.add(subcategory.imageLists[i].url);
      listNames.add(subcategory.imageLists[i].name);
    }
    return appState.copyWith(
      newEvent: appState.newEvent.copyWith(
        name: subcategory.name,
        categoryId: category.id,
        subcategoryId: subcategory.id,
        imageUrls: _list,
        imageUrlsNames: listNames,
        imageUrl: subcategory.banner,
        thumbnail: subcategory.banner,
        isAdminEvent: isAdminEvent,
      ),
    );
  }
}

class UpdateEvent {
  final EventModel event;

  UpdateEvent(this.event);

  reducer(AppState appState) {
    return appState.copyWith(
      newEvent: event,
    );
  }
}

class SetCategories {
  final List<EventCategoryModel> categories;

  SetCategories(this.categories);

  reducer(AppState appState) {
    if (_debug) print("SetCategories.reducer ${categories.length} categories ingested");
    return appState.copyWith(
      eventCategories: categories,
    );
  }
}

class IncrementEventParticipantsNo {
  reducer(AppState appState) {
    return appState.copyWith(
      newEvent: appState.newEvent.copyWith(maxParticipantsNo: appState.newEvent.maxParticipantsNo + 1),
    );
  }
}

class DecrementEventParticipantsNo {
  reducer(AppState appState) {
    if (appState.newEvent.maxParticipantsNo <= 0) {
      return appState;
    }
    return appState.copyWith(
      newEvent: appState.newEvent.copyWith(maxParticipantsNo: appState.newEvent.maxParticipantsNo - 1),
    );
  }
}

class SetUnlimitedEventParticipantsNo {
  bool unlimited;

  SetUnlimitedEventParticipantsNo(this.unlimited);

  reducer(AppState appState) {
    if (unlimited) {
      return appState.copyWith(
        newEvent: appState.newEvent.copyWith(maxParticipantsNo: null, isUnLimitActivities: true),
      );
    }
    return appState.copyWith(
      newEvent: appState.newEvent.copyWith(maxParticipantsNo: 1, isUnLimitActivities: false),
    );
  }
}

class SetEventOwner {
  reducer(AppState appState) {
    return appState.copyWith(
      newEvent: appState.newEvent.copyWith(
        ownerId: appState.user.uid,
        ownerImageUrl: appState.user.avatar,
      ),
    );
  }
}

class SetEventGender {
  GenderType gender;

  SetEventGender({this.gender});

  reducer(AppState appState) {
    return appState.copyWith(newEvent: appState.newEvent.copyWith(gender: gender));
  }
}

class SetEventLanguage {
  String language;

  SetEventLanguage({this.language});

  reducer(AppState appState) {
    return appState.copyWith(newEvent: appState.newEvent.copyWith(language: language));
  }
}

class SetEventRequirements {
  List<PostRequirement> requirements;

  SetEventRequirements({this.requirements});

  reducer(AppState appState) {
    return appState.copyWith(newEvent: appState.newEvent.copyWith(requirements: requirements));
  }
}

class SetEventFilter {
  FilterModel filter;

  SetEventFilter({this.filter});

  reducer(AppState appState) {
    return appState.copyWith(filter: filter);
  }
}
