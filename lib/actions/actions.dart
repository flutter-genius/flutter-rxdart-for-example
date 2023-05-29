import 'package:hittapa/models/models.dart';
import 'package:redux/redux.dart';
import 'events.dart';
export 'events.dart';

import 'package:hittapa/services/node_service.dart';

 bool _debug = true;

void start(Store<AppState> store) async {
//  Stream<QuerySnapshot> categoriesStream =
//      Firestore.instance.collection(FB.CATEGORIES_COLLECTION).snapshots();
//  await for (var categoriesSnapshot in categoriesStream) {
//    store.dispatch(SetCategories(categoriesSnapshot.documents
//        .map((category) => EventCategoryModel.fromFB(category))
//        .where((category) => category.subcategories != null)
//        .toList()));
//  }

  var _result = await NodeService().getCategories();
  if(_result != null && _result['data'] != null){
    var _categories = _result['data'];
    List<EventCategoryModel> _listCategories = [];
    for(int i=0; i<_categories.length; i++){
      if(_categories[i]['subcategories'] != null && _categories[i]['subcategories'].length >0){
        EventCategoryModel _category = EventCategoryModel.fromJson(_categories[i]);
        _listCategories.add(_category);
      }
    }
    store.dispatch(SetCategories(_listCategories));
  }

  _result = await NodeService().getBackground();
  if(_result != null && _result['data'] != null){
    var _backgroundImageData = _result['data'];
    BackgroundImageModel backgroundImage = BackgroundImageModel.fromJson(_backgroundImageData);
    store.dispatch(SetBackgroundImage(backgroundImage));
  }
}

class DisableFirstRun {
  reducer(AppState state) {
    return state.copyWith(firstRun: false);
  }
}


class SetBackgroundImage {
  final BackgroundImageModel backgroundImage;

  SetBackgroundImage(this.backgroundImage);

  reducer(AppState appState) {
    return appState.copyWith(
      backgroundImage: backgroundImage,
    );
  }
}

class UpdateIsTop {
  final bool isTop;

  UpdateIsTop(this.isTop);

  reducer(AppState appState) {
    return appState.copyWith(
      isTop: isTop,
    );
  }
}

class SetGeoLocationData {
  final GeoLocationModel geoLocationData;

  SetGeoLocationData(this.geoLocationData);

  reducer(AppState appState) {
    if (_debug)
      print("SetgeoLocationData.reducer ${geoLocationData.geoLatitude}");
    return appState.copyWith(
      geoLocationData: geoLocationData,
    );
  }
}
