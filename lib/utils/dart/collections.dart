extension Raising<E> on List<E>{
  int indexWhereRaising(bool Function(E element) test, {int start = 0}){
    final index = indexWhere(test, start);
    if (index == -1){
      throw ArgumentError('No matching element was found');
    }
    return index;
  }
}