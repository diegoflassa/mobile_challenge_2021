extension ListExtensions<E> on List<E> {
  void addAllUnique(Iterable<E> iterable, {bool removeNotFound = false}) {
    if (removeNotFound) {
      for (final element in this) {
        if (!iterable.contains(element)) {
          remove(element);
        }
      }
    }
    for (final element in iterable) {
      if (!contains(element)) {
        add(element);
      }
    }
  }

  bool containsAll(Iterable<E> iterable) {
    var ret = true;
    for (final element in iterable) {
      if (!contains(element)) {
        ret = false;
        break;
      }
    }
    return ret;
  }
}
