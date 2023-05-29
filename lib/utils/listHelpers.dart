Iterable removeNulls(Iterable l) {
  var r = l.toList();
  r.removeWhere((e) => e == null);
  return r;
}
