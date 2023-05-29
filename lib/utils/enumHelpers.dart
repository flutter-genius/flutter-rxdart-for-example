class _EnumHelper {
  var cache = {};

  /// Converts string to given enum value.
  /// [enumValues] is EnumType.values. We can't pass enums as a function parameter.
  dynamic str2enum(dynamic enumValues, String str) {
    var o = {};
    if (!cache.containsKey(enumValues)) {
      for (var i in enumValues) {
        o[i.toString().split(".").last] = i;
      }
      cache[enumValues] = o;
    } else {
      o = cache[enumValues];
    }
    return o[str];
  }

  String enum2str(dynamic e) {
    if (e == null) return "";
    return e.toString().split('.')[1];
  }
}

_EnumHelper enumHelper = _EnumHelper();
