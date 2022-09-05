import 'package:collection/collection.dart';

extension ListExtensions<E> on List<E>{
  int indexWhereRaising(bool Function(E element) test, {int start = 0}){
    final index = indexWhere(test, start);
    if (index == -1){
      throw ArgumentError('No matching element was found');
    }
    return index;
  }
}

extension IterableExtensions<E> on Iterable<E>{
  List<E> applyMask(Iterable<bool> mask) => [
    for (var pair in IterableZip([this, mask])) if (pair[1] == true) pair[0] as E
  ];
}

extension MapExtensions<K, V> on Map<K, V>{
  V getValue(K key) => this[key]!;
  T getCasted<T>(K key) => this[key]! as T;
  V getOrFallback(K key, V fallback) => this[key] ?? fallback;
  V getOrKey(K key) => this[key] ?? key as V;
}

Iterable<bool> invertedMask(Iterable<bool> mask) sync*{
  for (bool el in mask) {
    yield !el;
  }
}