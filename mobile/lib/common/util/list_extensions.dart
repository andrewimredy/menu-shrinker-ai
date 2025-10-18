extension ListExtensions<E> on List<E> {
  List<E> filter(bool Function(E element) test) => where(test).toList();

  List<List<E>> chunked(int chunkSize) {
    final chunks = <List<E>>[];
    for (var i = 0; i < length; i += chunkSize) {
      final end = i + chunkSize;
      chunks.add(sublist(i, end > length ? length : end));
    }
    return chunks;
  }

  E? elementAtOrNull(int index) => index < length ? elementAt(index) : null;

  E? get firstOrNull => isEmpty ? null : first;

  E? get lastOrNull => isEmpty ? null : last;

  E? firstWhereOrNull(bool Function(E element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  /// Example:
  ///
  /// ```dart
  /// final debtMap = debts.associateBy((it) => it.name);
  /// ```
  Map<K, E> associateBy<K>(K Function(E element) keyEvaluator) {
    final map = <K, E>{};
    for (final item in this) {
      final key = keyEvaluator(item);
      map[key] = item;
    }
    return map;
  }

  Map<K, V> associate<K, V>(K Function(E element) keyEvaluator,
      V Function(E element) valueTransform) {
    final map = <K, V>{};
    for (final item in this) {
      final key = keyEvaluator(item);
      final value = valueTransform(item);
      map[key] = value;
    }
    return map;
  }
}

List<E> generateSeparatedList<E>(
  int itemCount, {
  required ListItemBuilder<E> itemBuilder,
  required ListItemBuilder<E> separatorBuilder,
}) {
  if (itemCount == 0) return <E>[];
  return List.generate(itemCount * 2 - 1, (index) {
    final itemIndex = index ~/ 2;
    return index % 2 == 1
        ? separatorBuilder(itemIndex)
        : itemBuilder(itemIndex);
  });
}

typedef ListItemBuilder<T> = T Function(int index);
