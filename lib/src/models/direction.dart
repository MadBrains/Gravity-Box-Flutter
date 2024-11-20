/// A direction on a 2D plane.
///
/// The 2D plane can be thought of as a mobile screen, where
/// [Direction.values] is the sides of the screen respectively.
enum Direction {
  /// The left side of the 2D plane.
  left,

  /// The top side of the 2D plane.
  top,

  /// The right side of the 2D plane.
  right,

  /// The bottom side of the 2D plane.
  bottom;

  /// Whether this direction is [Direction.left].
  bool get isLeft => this == Direction.left;

  /// Whether this direction is [Direction.top].
  bool get isTop => this == Direction.top;

  /// Whether this direction is [Direction.right].
  bool get isRight => this == Direction.right;

  /// Whether this direction is [Direction.bottom].
  bool get isBottom => this == Direction.bottom;

  /// Whether this direction is either [Direction.left] or [Direction.right].
  bool get isHorizontal => isLeft || isRight;

  /// Whether this direction is either [Direction.top] or [Direction.bottom].
  bool get isVertical => isTop || isBottom;

  /// The opposite direction of this direction.
  ///
  /// For example, the opposite direction of [Direction.left] is [Direction.right].
  Direction get opposite => switch (this) {
        Direction.left => Direction.right,
        Direction.top => Direction.bottom,
        Direction.right => Direction.left,
        Direction.bottom => Direction.top
      };

  /// The adjacent direction of this direction clockwise.
  ///
  /// For example, the clockwise adjacent direction of [Direction.left] is [Direction.bottom].
  Direction get clockwiseAdjacent => switch (this) {
        Direction.left => Direction.bottom,
        Direction.top => Direction.left,
        Direction.right => Direction.top,
        Direction.bottom => Direction.right
      };
}
