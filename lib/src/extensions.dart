import 'models/models.dart';

extension IterableX<T> on Iterable<T> {
  bool containsWhere(bool Function(T element) test) {
    for (T e in this) {
      if (test(e)) return true;
    }

    return false;
  }
}

extension SetDirectionX on Set<Direction> {
  bool get containsHorizontal => contains(Direction.left) || contains(Direction.right);
  bool get containsVertical => contains(Direction.top) || contains(Direction.bottom);

  bool get isFull => length == Direction.values.length;
  bool get isNotFull => !isFull;

  bool isMovingHorizontal(Set<Direction> possibleDirections) =>
      possibleDirections.contains(Direction.left) && contains(Direction.left) ||
      possibleDirections.contains(Direction.right) && contains(Direction.right);

  bool isMovingVertical(Set<Direction> possibleDirections) =>
      possibleDirections.contains(Direction.top) && contains(Direction.top) ||
      possibleDirections.contains(Direction.bottom) && contains(Direction.bottom);

  bool isRollingClockwise(Set<Direction> possibleDirections) =>
      Direction.values.any((Direction direction) =>
          !possibleDirections.contains(direction) && contains(direction.clockwiseAdjacent));
}
